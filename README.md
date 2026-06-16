# 🚀 astro-gcp-cloudrun-starter — GCP Cloud Run Starter Template

<img src="https://raw.githubusercontent.com/arthelokyo/.github/main/resources/astrowind/lighthouse-score.png" align="right"
     alt="Lighthouse score of the base theme" width="100" height="358">

🌟 _Front end built on **AstroWind** — one of the most *starred* & *forked* Astro themes (2022–2025)._ 🌟

**astro-gcp-cloudrun-starter is a production-ready, open-source (MIT) GitHub template that deploys an [Astro](https://astro.build/) v6 + [Tailwind CSS](https://tailwindcss.com/) v4 website to [Google Cloud Run](https://cloud.google.com/run) using keyless Workload Identity Federation, Terraform-managed infrastructure, and a scale-to-zero cost profile of roughly $0/month.** Branch it (or use it as a GitHub Template) to stand up any containerized web app on GCP with a secure, **zero-secrets-in-git** foundation.

For setting up and deploying the infrastructure, start here:

- [Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md) — zero to a live Cloud Run URL, in order.
- [Template Quickstart](./docs/TEMPLATE_SETUP.md) — How to use this repository as a starter template.
- [Setup Playbook](./docs/SETUP_PLAYBOOK.md) — Initial manual bootstrap and Terraform backend migration.
- [IaC Governance Rules](./docs/IAC_RULES.md) — The 9 developer rules for managing infrastructure changes.

### Front-end features

- ✅ **Production-ready** scores in **PageSpeed Insights** reports.
- ✅ Integration with **Tailwind CSS v4** supporting **Dark mode** and **_RTL_**.
- ✅ **Fast and SEO friendly blog** with automatic **RSS feed**, **MDX** support, **Categories & Tags**, **Social Share**, ...
- ✅ **Image Optimization** (using new **Astro Assets** and **Unpic** for Universal image CDN).
- ✅ Generation of **project sitemap** based on your routes.
- ✅ **Open Graph tags** for social media sharing.
- ✅ **Analytics** built-in Google Analytics 4 (with **Consent Mode v2**) and Splitbee integration.

### Platform & optimization features

- ✅ **Keyless deploys** — GitHub Actions → GCP via Workload Identity Federation (OIDC), scoped to **this repo**. No JSON keys.
- ✅ **Infrastructure as code** — Terraform layers (bootstrap → shared → environment); state in GCS.
- ✅ **Scale-to-zero cost** — `min-instances = 0`, capped autoscaling, a billing budget with alerts (≈ $0/month, estimate).
- ✅ **Core Web Vitals enforced in CI** — a Lighthouse budget fails PRs on LCP/CLS regressions.
- ✅ **GEO / AI discoverability** — schema.org JSON-LD + `llms.txt` so AI search engines can cite the site.
- ✅ **WCAG 2.2 AA** — contrast in both themes, `prefers-reduced-motion`, skip link, semantic landmarks.

<br>

![astro-gcp-cloudrun-starter Theme Screenshot](https://raw.githubusercontent.com/arthelokyo/.github/main/resources/astrowind/screenshot-astrowind-readme-fina-v1.png)

[![License](https://img.shields.io/github/license/adammerrill/astro-gcp-cloudrun-starter?style=flat-square&color=dddddd&labelColor=000000)](https://github.com/adammerrill/astro-gcp-cloudrun-starter/blob/main/LICENSE.md)
[![Maintained](https://img.shields.io/badge/maintained%3F-yes-brightgreen.svg?style=flat-square)](https://github.com/adammerrill/astro-gcp-cloudrun-starter)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/adammerrill/astro-gcp-cloudrun-starter#contributing)
[![Known Vulnerabilities](https://snyk.io/test/github/adammerrill/astro-gcp-cloudrun-starter/badge.svg?style=flat-square)](https://snyk.io/test/github/adammerrill/astro-gcp-cloudrun-starter)
[![Stars](https://img.shields.io/github/stars/adammerrill/astro-gcp-cloudrun-starter.svg?style=social&label=stars&maxAge=86400&color=ff69b4)](https://github.com/adammerrill/astro-gcp-cloudrun-starter)
[![Forks](https://img.shields.io/github/forks/adammerrill/astro-gcp-cloudrun-starter.svg?style=social&label=forks&maxAge=86400&color=ff69b4)](https://github.com/adammerrill/astro-gcp-cloudrun-starter)

<br>

<details open>
<summary>Table of Contents</summary>

- [Why this template](#why-this-template)
- [Demo](#demo)
- [Quickstart](#quickstart)
- [TL;DR](#tldr)
- [Getting started](#getting-started)
  - [Project structure](#project-structure)
  - [Commands](#commands)
  - [Configuration](#configuration)
  - [Customize Design](#customize-design)
  - [Deploy](#deploy)
- [Documentation](#documentation)
- [Roadmap](#roadmap)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Contributing](#contributing)
- [Acknowledgements](#acknowledgements)
- [License](#license)

</details>

<br>

## Why this template

| Pillar                     | What you get                                                                                                                                                        |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Keyless security**       | GitHub Actions → GCP via Workload Identity Federation (OIDC), scoped to **this exact repository**. No JSON keys to leak.                                            |
| **Infrastructure as code** | Terraform layers (bootstrap → shared → environment) provision projects, Artifact Registry, Cloud Run, IAM, monitoring, logging, and a billing budget. State in GCS. |
| **Scale-to-zero cost**     | `min-instances = 0`, a low max cap, smallest sensible CPU/memory, and a billing budget with alerts → ≈ **$0/month** within the free tier (estimate).                |
| **Fast & findable**        | Core Web Vitals enforced in CI (Lighthouse budget); schema.org JSON-LD + `llms.txt` so AI search engines can cite the site.                                         |
| **Accessible**             | WCAG 2.2 AA contrast (both themes), `prefers-reduced-motion`, skip link, semantic landmarks, labeled forms.                                                         |
| **Measured**               | Privacy-first GA4 + Consent Mode v2 conversion tracking (off until you set a Measurement ID).                                                                       |

## Demo

📌 The live example is deployed to **Google Cloud Run** from this repository by the [deploy workflow](.github/workflows/deploy-dev.yml). To stand up your own public URL, follow the [Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md). Repo: [github.com/adammerrill/astro-gcp-cloudrun-starter](https://github.com/adammerrill/astro-gcp-cloudrun-starter/).

## Quickstart

1. **Use this template** on GitHub (or clone it).
2. Run the site locally: `npm install && npm run dev` (→ `localhost:4321`).
3. Deploy to GCP: follow the [Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md) — a clean GCP account to a live, public Cloud Run URL in ~30–45 minutes.

## TL;DR

```shell
npm create astro@latest -- --template adammerrill/astro-gcp-cloudrun-starter
```

## Getting started

**astro-gcp-cloudrun-starter** gives you quick access to creating a website using [Astro v6](https://astro.build/) + [Tailwind CSS v4](https://tailwindcss.com/). It focuses on simplicity, good practices and high performance.

Very little vanilla JavaScript is used — only to provide basic functionality — so each developer decides which framework (React, Vue, Svelte, Solid JS...) to use and how to approach their goals.

> **Note:** Requires **Node.js >= 22.12.0**. The site uses `output: 'static'`; the blog requires `prerender = true`. The root `Dockerfile` builds the static site and serves it with **nginx on port 8080** (the port Cloud Run sends traffic to).

### Project structure

Inside the template you'll see the following folders and files:

```
/
├── .github/workflows/        # ci.yml (check + docker + terraform-validate + lighthouse)
│   ├── ci.yml                # + deploy-dev / deploy-staging / deploy-prod (keyless, app-deploy-only)
│   └── deploy-*.yml
├── public/
│   ├── robots.txt            # standard + explicit AI-crawler policy
│   ├── llms.txt              # curated LLM index (llmstxt.org)
│   └── _headers
├── src/
│   ├── assets/styles/tailwind.css
│   ├── components/
│   │   ├── blog/  common/  ui/  widgets/
│   │   ├── common/Analytics.astro       # GA4 + Consent Mode v2 (privacy-first)
│   │   ├── common/StructuredData.astro  # renders schema.org JSON-LD
│   │   ├── CustomStyles.astro
│   │   ├── Favicons.astro
│   │   └── Logo.astro
│   ├── content.config.ts
│   ├── data/post/            # blog posts (.md, .mdx)
│   ├── layouts/              # Layout.astro, PageLayout.astro, MarkdownLayout.astro
│   ├── pages/                # file-based routing (index, 404, [...blog], rss.xml.ts, ...)
│   ├── utils/
│   │   ├── schema.ts         # config-driven schema.org JSON-LD builders
│   │   └── ...
│   ├── config.yaml
│   └── navigation.ts
├── terraform/
│   ├── bootstrap/            # one-time seed: projects, state bucket, admin SA
│   ├── environments/         # shared, dev, staging, production
│   └── modules/              # iam, cloud_run, artifact_registry, monitoring, ...
├── docs/                     # all guides (indexed below)
├── Dockerfile                # multi-stage: Node 22 build → nginx:8080 (~25MB, non-root)
├── lighthouserc.json         # Lighthouse CI Core Web Vitals budget
├── astro.config.ts
└── package.json
```

Astro looks for `.astro` or `.md` files in `src/pages/`. Each page is exposed as a route based on its file name.

There's nothing special about `src/components/`, but that's where we put any Astro/React/Vue/Svelte/Preact components.

Static assets like images can be placed in `public/` (no transformation) or in `assets/` (imported directly).

[![Edit on CodeSandbox](https://codesandbox.io/static/img/play-codesandbox.svg)](https://githubbox.com/adammerrill/astro-gcp-cloudrun-starter/tree/main) [![Open in StackBlitz](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/github/adammerrill/astro-gcp-cloudrun-starter)

> 🧑‍🚀 **Seasoned astronaut?** Update `src/config.yaml` and the content, set your GCP values per the walkthrough, and have fun!

<br>

### Commands

All commands are run from the root of the project, from a terminal:

| Command             | Action                                                                  |
| :------------------ | :---------------------------------------------------------------------- |
| `npm install`       | Installs dependencies                                                   |
| `npm run dev`       | Starts local dev server at `localhost:4321`                             |
| `npm run build`     | Build your production site to `./dist/`                                 |
| `npm run preview`   | Preview your build locally, before deploying                            |
| `npm run check`     | Check your project for errors (astro + ESLint + Prettier) — the CI gate |
| `npm run fix`       | Run ESLint and format code with Prettier                                |
| `npm run astro ...` | Run CLI commands like `astro add`, `astro preview`                      |

<br>

### Configuration

Basic configuration file: `./src/config.yaml`

```yaml
site:
  name: astro-gcp-cloudrun-starter
  site: 'https://astro-gcp-cloudrun-starter.run.app' # replace with your Cloud Run URL or custom domain
  base: '/' # Change this if you need to deploy to a sub-path
  trailingSlash: false # Generate permalinks with or without "/" at the end

  googleSiteVerificationId: false # Or some value

# Default SEO metadata
metadata:
  title:
    default: astro-gcp-cloudrun-starter
    template: '%s — astro-gcp-cloudrun-starter'
  description: '🚀 A production-ready Astro + GCP Cloud Run starter template ...'
  robots:
    index: true
    follow: true
  openGraph:
    site_name: astro-gcp-cloudrun-starter
    images:
      - url: '~/assets/images/default.png'
        width: 1200
        height: 628
    type: website
  twitter:
    handle: '@adammerrill'
    site: '@adammerrill'
    cardType: summary_large_image

i18n:
  language: en
  textDirection: ltr

apps:
  blog:
    isEnabled: true # If the blog will be enabled
    postsPerPage: 6 # Number of posts per page

    post:
      isEnabled: true
      permalink: '/%slug%' # Variables: %slug%, %year%, %month%, %day%, %hour%, %minute%, %second%, %category%
      robots:
        index: true

    list:
      isEnabled: true
      pathname: 'blog' # Blog main path, you can change this to "articles" (/articles)
      robots:
        index: true

    category:
      isEnabled: true
      pathname: 'category' # Category main path /category/some-category
      robots:
        index: true

    tag:
      isEnabled: true
      pathname: 'tag' # Tag main path /tag/some-tag
      robots:
        index: false

    isRelatedPostsEnabled: true # Show a related-posts widget below each post
    relatedPostsCount: 4 # Number of related posts to display

analytics:
  vendors:
    googleAnalytics:
      id: null # set your GA4 "G-XXXXXXXXXX" Measurement ID to enable analytics

ui:
  theme: 'system' # Values: "system" | "light" | "dark" | "light:only" | "dark:only"
```

<br>

#### Customize Design

With Tailwind CSS v4, all configuration is CSS-first. To customize font families, colors or other elements:

- `src/components/CustomStyles.astro` — CSS variables for colors and fonts (the `--aw-*` design tokens; AA-verified in both themes)
- `src/assets/styles/tailwind.css` — Tailwind theme tokens (`@theme`), custom utilities (`@utility`), plugins, and the `prefers-reduced-motion` fallback

### Deploy

The primary, supported target is **Google Cloud Run** (keyless, Terraform-managed). The static build can also be deployed to other static hosts.

#### Deploy to Google Cloud Platform (GCP) — primary

Keyless deploys via Workload Identity Federation with Terraform-managed infrastructure (Cloud Run, WIF, Artifact Registry, IAM, monitoring, budgets). Start with:

- [Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md) — zero to a live URL.
- [Setup Playbook](./docs/SETUP_PLAYBOOK.md) — bootstrap + Terraform backend migration.
- [IaC Governance Rules](./docs/IAC_RULES.md) — the 9 rules for managing infrastructure changes.

Once configured, every push to `main` builds the container, pushes it to Artifact Registry, and deploys a new Cloud Run revision.

#### Deploy to production (manual)

Create an optimized production build with:

```shell
npm run build
```

All generated files are in the `dist` folder, which you can deploy to any static hosting service.

#### Deploy to Netlify

Clone this repository on your own GitHub account and deploy it to Netlify:

[![Netlify Deploy button](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/adammerrill/astro-gcp-cloudrun-starter)

#### Deploy to Vercel

Clone this repository on your own GitHub account and deploy to Vercel:

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fadammerrill%2Fastro-gcp-cloudrun-starter)

#### Deploy to PandaStack

Clone this repository on your own GitHub account and deploy to PandaStack:

[![Deploy to PandaStack](https://dashboard.pandastack.io/deploy-button.svg)](https://dashboard.pandastack.io/deploy?repo=adammerrill/astro-gcp-cloudrun-starter&type=static&buildCmd=npm+run+build&outputDir=dist)

<br>

## Documentation

All guides live in [`docs/`](./docs):

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

## Roadmap

Ideas and feedback shape where this template goes next. Share suggestions in the project's [GitHub Discussions](https://github.com/adammerrill/astro-gcp-cloudrun-starter/discussions) or open an issue.

## Frequently Asked Questions

**Why this template?**
To get a real web app onto Google Cloud Run the secure, cheap, reproducible way — keyless (no service-account keys), fully Terraform-managed, and scale-to-zero — without rediscovering the setup the hard way.

**How much does the demo cost to run?**
Effectively ~$0/month. With `min-instances = 0` the service scales to zero and isn't billed while idle, and a low-traffic static demo stays within Cloud Run's perpetual free tier. A billing budget alert is created automatically. (An estimate — model your traffic with the GCP pricing calculator.)

**Is it safe that the repo is public?**
Yes — that's the design. Identity is keyless via Workload Identity Federation, so there's no key to leak. No secrets live in files, history, or CI logs; only `.example` placeholders are committed.

**Can I use a framework other than Astro?**
Yes. The root `Dockerfile` is the contract: build your app and serve it on port 8080. The Terraform foundation and CI are framework-agnostic.

**How do I deploy it?**
Follow the [Fresh User Walkthrough](./docs/FRESH_USER_WALKTHROUGH.md): bootstrap → shared → dev → set GitHub Variables → push to `main`.

## Contributing

If you have any ideas, suggestions or find any bugs, feel free to open a discussion, an issue or create a pull request. Infrastructure changes follow the [IaC Governance Rules](./docs/IAC_RULES.md): edit Terraform, open a PR, never click-ops in the console.

## Acknowledgements

The front end is built on **[AstroWind](https://github.com/onwidget/astrowind)**, initially created by **Arthelokyo**, and is maintained by a community of [contributors](https://github.com/adammerrill/astro-gcp-cloudrun-starter/graphs/contributors). The GCP/IaC/CI foundation and the web-optimization passes were added on top.

## License

**astro-gcp-cloudrun-starter** is licensed under the MIT license — see the [LICENSE](./LICENSE.md) file for details.
