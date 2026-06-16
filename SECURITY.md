# Security Policy & Secret-Scanning

This is a **public** repository. The rule is absolute: **no secret or sensitive
value ever reaches the repo or its history.** Identity is keyless (Workload
Identity Federation — there are **no service-account JSON keys** to leak), and
only placeholder `.example` files are committed.

Secret protection is **layered** — three independent gates, because each covers
a different point and they complement rather than replace each other.

## The three layers

| Layer         | Tool                                                                                     | Gate                         | What it does                                                                                                                                    |
| ------------- | ---------------------------------------------------------------------------------------- | ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 1. Pre-commit | **Gitleaks**                                                                             | before a commit exists       | Sub-second scan of the staged diff; blocks the commit locally.                                                                                  |
| 2. CI         | **Gitleaks + TruffleHog**                                                                | every PR & push              | Gitleaks (fast, SARIF → Security tab) + TruffleHog **credential verification** (fails the build on a _live_ secret). Weekly full-history sweep. |
| 3. Platform   | **GitHub Advanced Security** (Secret Protection · Push Protection · CodeQL · Dependabot) | at `git push` & continuously | GitHub-native backstop: blocks known secret patterns at push even if layers 1–2 were skipped, plus continuous secret/code/dependency scanning.  |

## Layer 1 — install the pre-commit hook (one step)

Pick either method:

**A. pre-commit framework (recommended):**

```bash
pipx install pre-commit   # or: pip install pre-commit
pre-commit install        # installs the Gitleaks hook from .pre-commit-config.yaml
```

**B. native git hook (no Python):**

```bash
git config core.hooksPath .githooks   # uses .githooks/pre-commit
```

Both require [`gitleaks`](https://github.com/gitleaks/gitleaks) on your PATH and
use the repo's `.gitleaks.toml` allowlist.

## Layer 2 — CI (already configured)

`.github/workflows/secret-scan.yml` runs on every PR, every push to `main`, and
weekly:

- **Gitleaks** uploads SARIF so findings appear under the repo's **Security →
  Code scanning** tab.
- **TruffleHog** scans with `--only-verified` and **fails the build on a verified
  (live) secret**. The PR job scans the diff; the scheduled/`main` job scans the
  **full history** (incremental scans can't see old commits).
- The gate is **fail-closed**: a real detection blocks the merge. (It was turned
  on only after a full local scan confirmed zero pre-existing findings — see
  "Baseline" below.)

## Layer 3 — GitHub-native backstop (✅ ENABLED)

GitHub Advanced Security is configured on this repo (**Settings → Advanced
Security**). Current state:

**Secret protection**

- ✅ **Secret Protection** (secret scanning) — GitHub continuously scans the
  public repo and alerts partners on detected secrets.
- ✅ **Push protection** — blocks commits containing supported secret patterns at
  `git push` time; the last line of defense if local hooks were bypassed.

**Code scanning (SAST — complements secret scanning)**

- ✅ **CodeQL analysis** — detects code vulnerabilities/errors (a full scan runs
  on enablement). Findings appear under **Security → Code scanning**, alongside
  the Gitleaks SARIF from Layer 2.
- ✅ **Copilot Autofix** — AI-suggested fixes for CodeQL alerts.
- ✅ **Least-privilege workflows** — CI workflows declare an explicit
  `permissions:` block (e.g. `ci.yml` is `contents: read`) so `GITHUB_TOKEN`
  isn't granted broad default scopes. This clears CodeQL's "Workflow does not
  contain permissions" alerts and is the standard for any new workflow.
- Check-runs failure threshold: Security = **High or higher**, Standard = **Only
  errors**. To _block merges_ on these alerts, create a branch ruleset
  (**Settings → Rules**) that requires the code-scanning check.

**Supply chain (Dependabot)**

- ✅ Dependency graph · ✅ Dependabot **alerts** (1 rule) · ✅ **malware alerts** ·
  ✅ **security updates** · ✅ **grouped security updates**.
- ✅ Dependabot **version updates** — configured in `.github/dependabot.yml`
  (weekly, grouped: npm, github-actions, docker base images).
- ⬜ Automatic dependency submission — off (not needed for this stack).

**Reporting**

- ✅ **Private vulnerability reporting** — researchers can report privately
  (**Security → Advisories**); see "Reporting a vulnerability" below.

> To review or change any of these: **Settings → Advanced Security**.

## Dependency security & vulnerability triage

Dependabot opens **version-update** PRs (weekly, grouped) and **security-update**
PRs. Routine flow: let CI (`npm run check` + Docker build + Lighthouse + CodeQL)
gate each PR, then merge group/patch/minor bumps when green; review majors
(e.g. TypeScript 6.0) deliberately before merging.

Not every alert has a clean fix — especially **transitive, dev/build-only**
packages pinned by a parent (e.g. `esbuild` via `vite`). Triage by **execution
path**, not severity label alone:

1. **Is a non-breaking fix in range?** Prefer it. A locked transitive version can
   lag the allowed range — `npm update <pkg>` bumps it without changing
   `package.json` (this is how `vite` was moved 7.3.3 → **7.3.5** to fix
   CVE-2026-53571, within the existing `^7` override). **Never** take a fix that
   force-downgrades a core dep (e.g. `npm audit fix --force` proposing an ancient
   `astro`).
2. **Is the vulnerable code actually reachable here?** This ships as a **static
   site** — Astro builds HTML in Linux CI, served by **nginx with no Node
   runtime**. Advisories that only affect a dev server, a non-npm runtime
   (Deno), or an OS we don't build on are **not in the execution path**. If so,
   and no in-range fix exists, **dismiss the alert** in **Security → Dependabot
   alerts** with reason **"Vulnerable code is not actually used"** and a one-line
   justification. Re-evaluate if the dependency later enters a runtime path.
3. **Stale alerts** (the flagged package is no longer in `package-lock.json`)
   auto-close on the next dependency-graph scan; dismiss if they linger.

Record non-obvious decisions in the PR or the dismissal note so the rationale is
auditable.

## Allowlist rationale (why the gate isn't noisy)

`.gitleaks.toml` allowlists values that match secret-shaped patterns but are
**not** secrets in this architecture:

- **Public GA4 Measurement ID** (`G-XXXXXXXXXX`) — publishable by design. (This
  stack uses **GA4 + Consent Mode v2**, _not_ PostHog.)
- **`.example` placeholders** (`YOUR_…`, `PREFIX-…`, `XXXXXX-XXXXXX-XXXXXX`).
- **Service-account emails and the WIF provider path** — non-secret under keyless
  federation; security comes from the repo-scoped attribute condition, not from
  hiding these strings.
- Build output (`dist/`), `node_modules/`, asset CDN hosts.

If a scan flags a confirmed false positive, add it to the `[allowlist]` in
`.gitleaks.toml` with a comment explaining why.

## If a secret IS found — response runbook (rotate first!)

A secret that has been in public git history must be treated as **compromised**,
even after removal. In order:

1. **ROTATE / revoke the credential at its source FIRST** (e.g., delete the GCP
   key, revoke the API token). This is the only step that actually stops the
   leak; removal alone does not.
2. **Remove it from the working tree** and replace with an env/Secret-Manager
   reference.
3. **Consider a history purge** (`git filter-repo` or BFG) **only as a deliberate,
   coordinated human action** — it rewrites history and requires a force-push that
   affects all collaborators. **Do not** do this automatically.
4. Add an allowlist entry only if it was a confirmed false positive.

## Where secrets actually live

- **CI auth:** keyless (Workload Identity Federation) — no SA JSON keys exist.
- **App runtime secrets:** Google Secret Manager, injected into Cloud Run.
- **Non-sensitive CI config:** GitHub Actions **Variables** (not Secrets).
- **Local:** untracked files (`terraform.tfvars`, `backend.tf`, `.env`) — all
  gitignored, with committed `.example` placeholders.

## Baseline (this setup)

A full local scan — **TruffleHog** (entire history, verification on) and
**Gitleaks** (history + working tree) — found **zero** verified or unverified
secrets in tracked content. The repo and its history are clean as of this
configuration.

## Reporting a vulnerability

Please open a private security advisory (**Security → Advisories → Report a
vulnerability**) rather than a public issue.
