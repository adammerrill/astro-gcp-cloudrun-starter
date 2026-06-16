# Gap Register — Repo vs. Actual Deploy Reality

This register reconciles what the repository/docs **said** against what it
**actually took** to deploy this template to Cloud Run on a clean GCP account.
Each row is a defect between the committed repo (LEFT) and the working
deployment (RIGHT). Severity: **BLOCKER** = a new user cannot deploy without
rediscovering this; **MAJOR** = significant friction/confusion; **MINOR** =
polish.

Status legend: ✅ remediated in this audit · 🩹 was self-healed during the
original deploy (PRs #2–#8) and is verified here.

| # | Dimension | Repo said / provided | Reality required | New-user impact | Severity | Status |
|---|-----------|----------------------|------------------|-----------------|----------|--------|
| 1 | 1.5 Config | `shared/terraform.tfvars.example` had no `project_id` / `project_name` | Both are required (used by `providers.tf` + `project_factory`) | Plan fails / wrong project targeted | BLOCKER | ✅ |
| 2 | 1.4 TF correctness | `create_project` defaulted to `true` in env layers | Bootstrap already creates the projects → env must **adopt** (`false`); `true` causes `billing.resourceAssociations.create` precondition error | Apply fails on first env | BLOCKER | ✅ |
| 3 | 1.2/1.6 IAM | Deploy SA only had `artifactregistry.writer` | CI also needs `run.developer` (env project) + `iam.serviceAccountUser` (runtime SA) | CI deploy 403s | BLOCKER | ✅ codified |
| 4 | 1.1 Setup docs | GitHub Actions **Variables** layer documented nowhere | 11 Variables + a `dev` Environment must be set for CI | CI cannot run at all | BLOCKER | ✅ documented |
| 5 | 1.5 Config | `service_name` defaulted to `astrowind` | Must equal the `SERVICE_NAME` GitHub var (`website`) or CI deploys a different service | Split-brain service / smoke test fails | MAJOR | ✅ |
| 6 | 1.6 Build | `TEMPLATE_SETUP` step 4: "`/app/` is a placeholder Node.js server; expose `$PORT`" | App is the Astro site at repo root; root `Dockerfile` builds it and serves via **nginx :8080**; `/app/` is unused | User edits the wrong files | MAJOR | ✅ (`/app` removed, docs fixed) |
| 7 | 1.3 APIs / 1.2 quota | Bootstrap hardcodes 4 projects; no quota note | New billing accounts hit a project-creation quota (we lost `staging`) | Confusing bootstrap failure | MAJOR | ✅ documented |
| 8 | 1.1 Setup docs | `SETUP_PLAYBOOK` referenced "M-1 to M-5" but only documented M-1/M-2; no build→deploy→verify | Full ordered path incl. shared+dev apply, GitHub vars, push-to-deploy, verify URL | Docs don't reach a running URL | BLOCKER | ✅ (walkthrough + playbook) |
| 9 | 1.4 TF / state | Playbook had users hand-edit `bootstrap/main.tf` to add the GCS backend | Cleaner as a copyable `backend.tf.example` (git-ignored real file) | Error-prone manual edit | MAJOR | ✅ codified |
| 10 | 1.7 Structure | README referenced both "8" and "9" governance rules | There are 9 | Minor confusion | MINOR | ✅ |
| — | 1.3 APIs | Seed enabled only 4 APIs | Needs `iamcredentials`, `cloudbilling`, `run`, `artifactregistry`, `secretmanager` | Apply fails per-API | BLOCKER | 🩹 PR #3/#4 |
| — | 1.4 TF | `providers.tf` used short-form impersonation scopes | `generateAccessToken` requires full scope URIs | Every env plan 400s | BLOCKER | 🩹 PR #3 |
| — | 1.2 IAM | Admin SA had only `editor` + `projectIamAdmin` | Also needs WIF/SA-admin/run/logging/monitoring/secret admin | Apply fails per-role | BLOCKER | 🩹 PR #4/#6 |
| — | 1.4 TF | Shared/env storage recreated the bootstrap state bucket | Must not duplicate (`create_state_bucket=false`) | 409 bucket conflict | BLOCKER | 🩹 PR #6 |
| — | 1.6 CI | Pipeline ran `terraform apply` (impersonation hang + local-state fallback) | App-deploy-only pipeline | CI hangs/destroys | BLOCKER | 🩹 PR #7 (staging/prod aligned here) |
| — | 1.2 IAM | Cross-project image pull undocumented | Env Cloud Run **service agent** needs AR reader on shared | Deploy fails on image pull | BLOCKER | 🩹 PR #8 |
| — | 0 Security | WIF scoped to the GitHub **owner** | Must be scoped to **this repo** | Any owned repo could federate | BLOCKER | 🩹 PR #2 |

## Summary

The repository self-healed ~9 BLOCKERs during the original deploy (PRs #2–#8).
This audit closes the **remaining** gaps that were worked around with `gcloud`
or local edits and never made it back into the repo — the deploy-SA roles
(#3), the `create_project`/shared-vars failures (#1, #2), the entirely
undocumented GitHub Variables layer (#4), plus the build-path and doc defects
(#5–#10). After remediation, every required value has an `.example`, every
former-manual IAM step is codified, and the documentation forms one ordered
path from zero to a live URL (`FRESH_USER_WALKTHROUGH.md`), satisfying IaC
Rule 8 (zero tribal knowledge).
