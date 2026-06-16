# astro-gcp-cloudrun-starter

**astro-gcp-cloudrun-starter is a production-ready, open-source (MIT) GitHub template that deploys an [Astro](https://astro.build/) v6 + [Tailwind CSS](https://tailwindcss.com/) v4 website to [Google Cloud Run](https://cloud.google.com/run) using keyless Workload Identity Federation, Terraform-managed infrastructure, and a scale-to-zero cost profile of roughly $0/month.**

It exists so any developer can branch it (or use it as a GitHub Template) and stand up a containerized web app on GCP with a **zero-secrets-in-git** foundation: no service-account keys anywhere, identity is keyless, and only placeholder `.example` files are committed to the public repo.

[![License: MIT](https://img.shields.io/github/license/adammerrill/astro-gcp-cloudrun-starter?style=flat-square)](./LICENSE.md)
[![Stars](https://img.shields.io/github/stars/adammerrill/astro-gcp-cloudrun-starter?style=flat-square)](https://github.com/adammerrill/astro-gcp-cloudrun-starter/stargazers)
[![Forks](https://img.shields.io/github/forks/adammerrill/astro-gcp-cloudrun-starter?style=flat-square)](https://github.com/adammerrill/astro-gcp-cloudrun-starter/network/members)

> **Demo:** the live example is deployed to Google Cloud Run from this repo. See [the deploy workflow](.github/workflows/deploy-dev.yml) and the [Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md) to stand up your own.

---

## Why this template

| Pillar                     | What you get                                                                                                                                                        |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Keyless security**       | GitHub Actions → GCP via Workload Identity Federation (OIDC), scoped to **this exact repository**. No JSON keys to leak.                                            |
| **Infrastructure as code** | Terraform layers (bootstrap → shared → environment) provision projects, Artifact Registry, Cloud Run, IAM, monitoring, logging, and a billing budget. State in GCS. |
| **Scale-to-zero cost**     | `min-instances = 0`, a low max cap, smallest sensible CPU/memory, and a billing budget with alerts → ≈ **$0/month** within the free tier (estimate).                |
| **Fast & findable**        | Core Web Vitals enforced in CI (Lighthouse budget); schema.org JSON-LD + `llms.txt` so AI search engines can cite the site.                                         |
| **Accessible**             | WCAG 2.2 AA contrast (both themes), `prefers-reduced-motion`, skip link, semantic landmarks, labeled forms.                                                         |
| **Measured**               | Privacy-first GA4 + Consent Mode v2 conversion tracking (off until you set a Measurement ID).                                                                       |

## Quickstart

1. **Use this template** on GitHub (or clone it).
2. Follow the **[Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md)** — the single authoritative path from a clean GCP account to a live, public Cloud Run URL (~30–45 min).
3. To run the site locally: `npm install && npm run dev` (→ `localhost:4321`).

> **Requires Node.js ≥ 22.12.0.** The site is `output: 'static'`; the root `Dockerfile` builds it and serves it with nginx on **port 8080**.

## Documentation

### Deploy & infrastructure

- **[Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md)** — zero to a live URL, in order.
- **[Setup Playbook](./docs/SETUP_PLAYBOOK.md)** — bootstrap + Terraform detail and state migration.
- **[Template Quickstart](./docs/TEMPLATE_SETUP.md)** — using this repo as a template; build/CI overview.
- **[IaC Governance Rules](./docs/IAC_RULES.md)** — the 9 rules that keep the infrastructure reproducible.
- **[Gap Register](./docs/GAP_REGISTER.md)** — the repo-vs-reality audit that hardened the deploy path.

### Web optimization (the 5-phase program)

- **[Performance & Crawler Access](./docs/PERFORMANCE_AND_CRAWLING.md)** — Core Web Vitals, Lighthouse CI budget, AI-crawler policy.
- **[GEO & Structured Data](./docs/GEO_STRUCTURED_DATA.md)** — schema.org JSON-LD, definition-first content, `llms.txt`.
- **[Styling & Accessibility](./docs/STYLING_ACCESSIBILITY.md)** — WCAG 2.2 AA contrast, reduced motion.
- **[Component Accessibility](./docs/COMPONENT_ACCESSIBILITY.md)** — semantics, skip link, keyboard a11y, minimal hydration.
- **[Conversion & Measurement](./docs/CONVERSION_MEASUREMENT.md)** — GA4 + Consent Mode v2, conversion events, AI-referral tracking.

## Project structure

```
src/                      # Astro v6 site: pages, components, content, config.yaml
  components/common/      # Metadata, Analytics (GA4 + Consent Mode v2), StructuredData
  utils/schema.ts         # config-driven schema.org JSON-LD builders
Dockerfile                # multi-stage: Node 22 build → nginx:8080 (~25MB, non-root)
public/                   # robots.txt (AI-crawler policy), llms.txt, static assets
.github/workflows/        # ci.yml (check + docker + terraform-validate + lighthouse),
                          # deploy-dev/staging/prod (keyless, app-deploy-only)
terraform/                # bootstrap, environments (shared/dev/staging/production), modules
docs/                     # all guides (indexed above)
```

## Commands

| Command           | Action                          |
| :---------------- | :------------------------------ |
| `npm install`     | Install dependencies            |
| `npm run dev`     | Dev server at `localhost:4321`  |
| `npm run build`   | Production build to `./dist/`   |
| `npm run preview` | Preview the build locally       |
| `npm run check`   | astro check + ESLint + Prettier |
| `npm run fix`     | Auto-fix ESLint + Prettier      |

## Configuration

Site content/SEO is in `src/config.yaml` (site name, metadata, analytics). Set your own **Cloud Run / custom domain** as `site:` and, to enable analytics, your GA4 **Measurement ID** under `analytics.vendors.googleAnalytics.id`.

## Contributing

Issues, discussions, and PRs are welcome. Infrastructure changes follow the [IaC Governance Rules](./docs/IAC_RULES.md): edit Terraform, open a PR, never click-ops in the console.

## License

MIT — see [LICENSE.md](./LICENSE.md). Originally derived from the AstroWind theme by Arthelokyo; reworked into a GCP Cloud Run starter.
