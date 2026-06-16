# Agent Instructions — astro-gcp-cloudrun-starter

## Project Overview

**astro-gcp-cloudrun-starter** is a production-ready, open-source GitHub template that deploys an **Astro v6 + Tailwind CSS v4** static site to **Google Cloud Run** with a zero-secrets, keyless, Terraform-managed foundation. The front end is derived from the AstroWind theme; the project adds a complete GCP/IaC/CI layer and a 5-phase web-optimization pass (performance, GEO, styling, components, conversion).

**Stack:** Astro v6 | Tailwind CSS v4 | TypeScript 6.0 | MDX | Sharp · Docker (nginx:8080) · Google Cloud Run · Terraform · GitHub Actions (keyless WIF)

**Public-repo rule:** nothing sensitive ever enters files, history, or CI logs. Identity is keyless (Workload Identity Federation, scoped to this repo); only `.example` placeholders are committed. App runtime secrets → Google Secret Manager.

## Quick Reference

| Command           | Purpose                             |
| ----------------- | ----------------------------------- |
| `npm run dev`     | Start dev server at localhost:4321  |
| `npm run build`   | Production build to `./dist/`       |
| `npm run preview` | Preview production build locally    |
| `npm run check`   | Run astro check + ESLint + Prettier |
| `npm run fix`     | Auto-fix ESLint + Prettier issues   |

**Node.js requirement:** >= 22.12.0

## Architecture

### Directory Structure

```
src/
  assets/styles/tailwind.css   # Tailwind v4 config (themes, utilities, plugins)
  components/
    common/        # Shared: Image, Metadata, Analytics, ToggleTheme
    ui/            # Primitives: Button, Headline, WidgetWrapper, ItemGrid
    widgets/       # Page sections: Hero, Features, Pricing, Header, Footer
    blog/          # Blog: SinglePost, List, Pagination, Tags
    CustomStyles.astro  # CSS variables for colors and fonts
  content.config.ts    # Content Collections schema (Astro v6 location)
  data/post/           # Blog posts (.md, .mdx)
  layouts/             # Layout.astro, PageLayout.astro, MarkdownLayout.astro
  pages/               # File-based routing
  utils/               # blog.ts, images.ts, permalinks.ts, frontmatter.ts
  config.yaml          # Site configuration (loaded as virtual module)
  navigation.ts        # Navigation structure
  types.d.ts           # TypeScript type definitions
vendor/integration/    # Custom Astro integration for config loading
```

### Path Aliases

Use `~/` to import from `src/`:

```typescript
import Image from '~/components/common/Image.astro';
import { SITE } from 'astrowind:config';
```

### Configuration System

Site config lives in `src/config.yaml` and is loaded as a Vite virtual module `astrowind:config` by the custom integration in `vendor/integration/`. Exports: `SITE`, `I18N`, `METADATA`, `APP_BLOG`, `UI`, `ANALYTICS`.

## Tailwind CSS v4

Configuration is CSS-first in `src/assets/styles/tailwind.css`:

- **Theme tokens:** `@theme { --color-primary: var(--aw-color-primary); ... }`
- **Custom utilities:** `@utility bg-page { ... }`
- **Dark mode:** Class-based via `@variant dark (&:where(.dark, .dark *))`
- **Plugins:** `@plugin "@tailwindcss/typography"`
- **Custom variant:** `@custom-variant intersect (&:not([no-intersect]))`

CSS variables for colors/fonts are defined in `src/components/CustomStyles.astro` with light/dark theme variants.

The Vite plugin `@tailwindcss/vite` is configured in `astro.config.ts` (not as an Astro integration).

### Class Merging

Components use `twMerge` from `tailwind-merge` v3 for conditional class composition.

## Content Collections

Defined in `src/content.config.ts` using the Astro v6 Content Layer API with `glob()` loader. Posts are in `src/data/post/` as `.md` or `.mdx` files.

Post frontmatter: `title` (required), `publishDate`, `updateDate`, `draft`, `excerpt`, `image`, `category`, `tags`, `author`, `metadata`.

## Component Patterns

- Props extend interfaces from `~/types`
- Use `class:list` for conditional classes
- Use `twMerge()` when accepting className overrides
- Use named slots for layout composition
- Widget components accept standardized props (see `~/types`)

## Image Handling

`src/components/common/Image.astro` supports:

- Local images via `astro:assets` (optimized by Sharp)
- Remote images via Unpic CDN
- Allowed domains (for providers Unpic can't detect, processed by Sharp): `cdn.pixabay.com`

Hero images use `loading="eager"` and `fetchpriority="high"` (LCP). Non-hero images lazy-load and carry explicit dimensions (CLS-safe).

## SEO / GEO / Analytics layer

- `src/utils/schema.ts` — config-driven **schema.org JSON-LD** builders (Organization, WebSite, SoftwareApplication, FAQPage, BlogPosting, BreadcrumbList). Never hardcode schema in components; add to this module.
- `src/components/common/StructuredData.astro` — renders JSON-LD; `Layout.astro` injects Organization + WebSite sitewide, pages append via the `structuredData` prop.
- `src/components/common/Analytics.astro` — GA4 with **Consent Mode v2** (storage denied by default), off unless `analytics.vendors.googleAnalytics.id` is set. Tracks no-PII conversion events.
- `public/robots.txt` (explicit AI-crawler policy) and `public/llms.txt` (LLM index).

## Infrastructure & CI/CD

- `terraform/` — `bootstrap` (projects, state bucket, admin SA), `environments/` (shared/dev/staging/production), and reusable `modules/`. State in GCS; identity keyless (WIF). See `docs/SETUP_PLAYBOOK.md` and `docs/FRESH_USER_WALKTHROUGH.md`.
- `.github/workflows/ci.yml` runs on PRs: `npm run check`, Docker build, `terraform validate` (all envs), and a **Lighthouse CI** Core Web Vitals budget.
- `deploy-dev/staging/prod.yml` are **app-deploy-only** (build image → push to Artifact Registry → deploy Cloud Run revision → smoke test). Terraform is run deliberately, not from CI.

### Security automation

Layered, defense-in-depth scanning — full runbook in `SECURITY.md`:

- **Secret scanning** — `.github/workflows/secret-scan.yml` (Gitleaks SARIF + TruffleHog `--only-verified`), a Gitleaks pre-commit hook (`.githooks/pre-commit` / `.pre-commit-config.yaml`), and GitHub push protection.
- **Code scanning (SAST)** — CodeQL on every PR; findings surface under **Security → Code scanning**. Keep it clean: workflows declare least-privilege `permissions:` (e.g. `ci.yml` is `contents: read`), and avoid the patterns CodeQL flags (e.g. complete, case-insensitive URL-scheme checks in `src/utils/permalinks.ts`).
- **Dependencies** — Dependabot **version updates** (`.github/dependabot.yml`, weekly grouped: npm / github-actions / docker) plus security updates. See `SECURITY.md` → "Dependency security & vulnerability triage" for how transitive, dev/build-only advisories are assessed (execution-path exposure) and remediated or dismissed.

## Documentation

All guides live in `docs/` and are indexed in `README.md` (deploy/infra + the 5-phase web-optimization docs). Security tooling and the dependency/vulnerability response runbook are in `SECURITY.md`.

## Verification Checklist

After changes, always verify:

1. `npm run build` succeeds
2. `npm run check` passes (astro check + ESLint + Prettier) — this is the CI gate
3. Don't regress the optimization invariants: valid JSON-LD, WCAG 2.2 AA contrast (both themes), skip link, minimal hydration, and the Lighthouse CWV budget (LCP ≤ 2.5s, CLS ≤ 0.1)
4. Visual check in browser: homepage, blog, dark mode, mobile menu, keyboard focus
