# Readiness Assessment — Fork-Fitness for Violet Crown Wellness (Amy McAbeer)

**Template:** `astro-gcp-cloudrun-starter` @ `main` (2d46c10, 17 PRs)
**Target use case:** a dual-audience (B2B + B2C) marketing / education / conversion site for a real holistic-wellness + corporate-wellness practitioner.
**Assessment type:** read-only fitness-for-purpose. No build, no fixes applied.

---

## EXECUTIVE VERDICT: ✅ GO

**Fork it now.** The foundation is solid, secure, documented, proven-deployable, and architecturally well-suited to a dual-audience marketing site. There are **no template-side blockers** and **no foundational defects that would force a costly rebuild later.**

Everything that's "missing" is **expected developer-build** (Amy's content, brand, booking wiring) — not template breakage. Two items deserve emphasis before the site goes **live** (not before forking): the demo pages ship **fabricated stats/testimonials** that must be purged, and the homepage **schema.org type is `SoftwareApplication`** (a dev tool) which must be swapped to practitioner types so search/AI engines describe Amy's business correctly.

### The only "do-this-early" punch list (none are blockers)

| # | Item | Type | Severity | Effort |
|---|------|------|----------|--------|
| 1 | Replace `getSoftwareApplicationSchema()` in `src/utils/schema.ts` with practitioner types (`Person` + `Service` + `LocalBusiness`/`HealthAndBeautyBusiness`) | template edit (1 file) | MAJOR *for GEO accuracy* | ~1–2 h |
| 2 | Delete/replace the demo pages carrying **fabricated stats** (`src/pages/homes/startup.astro`: "182K downloads, 116K clients, 4.8 rating") and the `homes/`+`landing/` persona demos | developer content | MAJOR *(integrity/legal)* | content task |
| 3 | Wire the **contact form to a real backend** (it currently has no `action`/handler) + add a **booking link/embed** (Calendly/Cal.com/Acuity) | developer-build | MAJOR *for conversion* | ~0.5–1 day |
| 4 | Re-point hardcoded project identity (`astro-gcp-cloudrun-starter` / repo URL appears in **25 files**, incl. `schema.ts`, `Analytics.astro`, `config.yaml`, `llms.txt`) | rebrand | MINOR | ~1–2 h |
| 5 | Add a **health/wellness disclaimer** slot (and update the generic `privacy.md`/`terms.md`) | developer content | MINOR *(advisable for health claims)* | content task |

**Net:** ~1 day of template-side prep + the expected content/branding build. No architecture change required.

---

## PHASE 0 — Orientation: what the template PROVIDES vs SCAFFOLDS vs ABSENT

| | |
|---|---|
| **Provides (works today)** | Keyless GCP Cloud Run deploy (Terraform + WIF, proven live), CI (check + docker + terraform-validate + **Lighthouse CWV budget**), a complete Astro v6 + Tailwind v4 front end, token-driven theming (light/dark, WCAG-AA verified), full SEO/GEO layer (schema.org JSON-LD, `llms.txt`, robots AI-policy, sitemap, OG/meta), GA4 + Consent Mode v2 conversion tracking, comprehensive docs. |
| **Scaffolds (developer fills in)** | Page content & copy, brand palette values, blog posts, navigation, services/offerings content, testimonials (real), contact-form backend, booking. |
| **Absent (developer must add)** | A booking/scheduling integration, a contact-form handler, a `services`/`offerings` content collection (only a `post`/blog collection exists), health-claim disclaimers, Amy's brand assets. |

---

## PHASE 1 — Foundational readiness (can it be forked & deployed?)

| Area | Rating | Evidence |
|------|--------|----------|
| **1.1 Duplicability** | **READY** (minor friction) | "Use this template" / `npm create astro --template` documented. Front end is application-agnostic (generic widgets). *Friction:* the repo identity string appears in **25 `src/`+`public/` files** (some hardcoded in `schema.ts`/`Analytics.astro`, not only config) → a fork must find-replace. Not a blocker. |
| **1.2 Secret-clean public repo** | **READY** ✅ | Verified during build-out: only `.example` files committed; real `terraform.tfvars`/`backend.tf`/`.tfstate` gitignored; **keyless WIF (no SA JSON keys)**; full-history grep for billing ID / project number = clean. **No BLOCKER here.** |
| **1.3 Onboarding docs** | **READY** ✅ | `FRESH_USER_WALKTHROUGH.md` is a single ordered path (fork → config → bootstrap → shared → dev → GitHub Variables → deploy, ~30–45 min); backed by `SETUP_PLAYBOOK`, `TEMPLATE_SETUP`, `IAC_RULES`, and a `GAP_REGISTER` of the reconciled deploy reality. |
| **1.4 Build & deploy** | **READY** ✅ | This exact repo was deployed to Cloud Run during build-out; CI is green (Astro build, `terraform validate` all envs, Docker build, Lighthouse). Documented path matches reality (the gap-register audit closed the deltas). |
| **1.5 Config/env** | **READY** ✅ | `src/config.yaml` is the single content/SEO/analytics config (loaded as a virtual module); every infra value has a commented `.example`; GitHub Variables documented. |

**Phase 1 verdict: no blockers. The foundation is fork-and-deploy ready.**

---

## PHASE 2 — Fitness for a dual-audience marketing/education site

| Area | Rating | Evidence |
|------|--------|----------|
| **2.1 Multi-audience architecture** | **READY** ✅ | The template ships **4 home variants** (`homes/saas`, `startup`, `mobile-app`, `personal`) and **6 landing variants** (`landing/lead-generation`, `sales`, `click-through`, `product`, `pre-launch`, `subscription`) from one codebase — a direct demonstration of distinct persona paths. A B2C section and a B2B section are a natural fit (see guidance below). |
| **2.2 Marketing primitives** | **READY** ✅ | Full widget library present: `Hero`/`Hero2`/`HeroText`, `Features`/`Features2`/`Features3`, `Content`, `Steps`/`Steps2`, `Pricing`, `Testimonials`, `Brands`, `Stats`, `FAQs`, `CallToAction`, `Contact`, blog widgets. Essentially every section a wellness/education marketing site needs already exists. |
| **2.3 Conversion readiness** | **NEEDS-BUILD** | CTAs and analytics plumbing are **present** (GA4 + Consent Mode v2 tracking `cta_use_template`, `outbound_click`, `form_submit`, `scroll_depth`). **But** the contact form has **no backend** (no `action`), and there is **no booking integration**. Conversion *measurement* is ready; conversion *capture* (form handler + booking link) is developer-build. **(Note: the brief mentioned PostHog — the template uses GA4, not PostHog.)** |
| **2.4 GEO/SEO/LLM discoverability** | **READY** (with a required type swap) | Strong: config-driven `schema.org` JSON-LD (`src/utils/schema.ts` + `StructuredData.astro`), `llms.txt`, robots AI-crawler policy, sitemap, `astro-seo` meta, fully SSR/static content. **Caveat:** the homepage emits **`SoftwareApplication` + a "free dev tool" `FAQPage`** — for Amy this must become `Person`/`Service`/`LocalBusiness`, or AI engines will mis-describe the business (punch-list #1). |
| **2.5 Styling/theming/brand** | **READY** ✅ | Token-driven via `--aw-*` CSS variables in `CustomStyles.astro` + Tailwind `@theme`; light/dark; **WCAG 2.2 AA contrast computed/verified in both themes**. Amy's paper/yellow/brown palette is a **token swap** (change `--aw-color-*` values) — the system supports it without a fight. *(One caveat: ~114 inherited raw palette utilities exist alongside tokens — documented as a follow-up in `STYLING_ACCESSIBILITY.md`; not blocking.)* |
| **2.6 Content-integrity guardrails** | **NEEDS-BUILD / CAUTION** | The GEO layer deliberately avoids fabricated `aggregateRating`. **However**, demo pages ship **fabricated stats** (`startup.astro`: 182K/116K/4.8) and generic testimonials that a fork inherits — these **must be purged** before a real practitioner's site goes live (integrity + health-claims sensitivity). No disclaimer scaffold exists yet. |
| **2.7 Accessibility & performance baseline** | **READY** ✅ | Skip link (WCAG 2.4.1), `prefers-reduced-motion`, AA contrast, semantic landmarks, labeled forms, required `alt`, **zero hydrated islands** (minimal INP), and a **Lighthouse CWV budget enforced in CI**. Excellent starting point. |

---

## PHASE 3 — Gap analysis

### A. MUST-FIX-IN-TEMPLATE-FIRST (defects forcing rework if forked now)

**None are blockers.** The genuinely template-side items are small and optional-to-early:

- **(MINOR, template polish)** `schema.ts` builders are hardcoded to this template's identity/types. Not a defect (it correctly describes *this* repo) but a fork must edit one file. Recommend documenting "swap the schema builders" in `TEMPLATE_SETUP`.
- **(MINOR)** Repo-identity string in 25 files → a documented find-replace would smooth forking.

> There are **no security, build, deploy, or architectural blockers**. The template is not broken, insecure, or unfit.

### B. EXPECTED-DEVELOPER-BUILD (Amy's job, not template defects)

- All site **content & copy** for both audiences; Amy's **bio/about**, **services/offerings**, real **testimonials**, education/blog articles.
- **Brand**: palette token values, fonts, logo, imagery.
- **Conversion capture**: contact-form backend (handler/service) + **booking** link/embed.
- **Schema type swap** to `Person`/`Service`/`LocalBusiness` (punch-list #1).
- **Purge demo content** (fake stats, demo personas) and add **health/wellness disclaimers**.
- Optional: a `services` **content collection** if offerings should be structured/data-driven (only `post` exists today).

### Dual-audience (B2B2C) architecture guidance — for the developer, up front

- **Split the journeys at the top level.** Use the existing pattern: e.g. `/` as a chooser/overview, `/individuals` (B2C: somatic/yoga/breathwork/biohacking) and `/business` (B2B: corporate wellness, executive sessions, speaking) — each its own `PageLayout` page composed from the **same widgets** with audience-specific copy. The `homes/*` and `landing/*` demos are your working templates for this.
- **Reuse, don't fork, components.** Drive B2C vs B2B differences through **props/config and content**, not duplicated components — the widget library is built for this.
- **Two CTAs, two funnels.** B2C → "Book a discovery call"; B2B → "Request a corporate consultation." Both are already trackable via the GA4 event layer (`cta_*`, `form_submit`); just wire the destinations.
- **Schema per audience.** Emit `Service` entries for each offering and a `Person`/`LocalBusiness` for Amy; this is what makes both a wellness seeker *and* a corporate buyer findable via search/AI.
- **Navigation** is config-driven (`src/navigation.ts`) — model the two audiences as top-level nav groups.

---

## Effort estimate

- **Template-side prep before building:** ~1 day (schema swap, identity re-point, delete demo pages, add disclaimer slot).
- **Then build the target site on the foundation:** content + brand + 2 audience sections + booking/form wiring — a normal small-marketing-site build; the foundation removes the infra/SEO/a11y/perf/CI work entirely.

## Bottom line

**GO.** This is a strong, secure, well-documented foundation that is *more* than fit for a dual-audience wellness marketing site — it already provides the infrastructure, SEO/GEO, accessibility, performance guardrails, and the full marketing-component library. The remaining work is the content/brand/booking the developer is expected to build, plus a short, well-understood prep list (chiefly: swap the schema type and purge demo stats before launch).
