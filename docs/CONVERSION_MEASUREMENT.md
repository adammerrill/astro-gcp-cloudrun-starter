# Phase 5 — Conversion & Measurement (plain-language guide)

The earlier phases made the site fast, findable, and solid. This phase turns
visitors into actions **and measures it honestly** — no dark patterns, no
fabricated numbers.

## Jargon, defined once

- **Conversion** — a visitor doing the thing you want (here: clicking "Use this
  template", or submitting the contact form).
- **GA4** — Google Analytics 4, Google's current analytics product.
- **Consent Mode v2** — Google's framework where analytics/ad cookies are
  **denied by default** until the visitor agrees. It's the privacy-respecting,
  EEA-compliant standard. Ref:
  [Google Consent Mode](https://developers.google.com/tag-platform/security/guides/consent).
- **Event** — a named, recorded action (e.g. `cta_use_template`).

## What we measure (and how it's privacy-respecting)

When you set a GA4 Measurement ID (see "Turning it on"), the site records these
**conversion events** — no personal data, no names/emails:

| Event              | Fires when                                           | Why it matters            |
| ------------------ | ---------------------------------------------------- | ------------------------- |
| `cta_use_template` | a visitor clicks any "Use this template" / repo link | your primary conversion   |
| `outbound_click`   | a visitor clicks any external link                   | where people go next      |
| `form_submit`      | the contact form is submitted                        | your secondary conversion |
| `scroll_depth`     | a visitor passes 25 / 50 / 75 / 100% of a page       | how engaging the page is  |

**Privacy:** Consent Mode v2 sets all storage to **denied by default**, so GA
runs in privacy-preserving **cookieless** mode and writes **no cookies** unless
a visitor opts in. IP anonymization is on. This is the "most common and best"
2026 privacy posture for GA4. To let visitors _opt in_ (and unlock full
analytics), add a consent banner / CMP (e.g. a simple banner, Cookiebot, or
Osano) that calls `gtag('consent','update',{ analytics_storage:'granted' })` and
sets `localStorage 'aw-consent' = 'granted'` (the code already re-applies that
saved choice on the next visit).

## How to read it (non-technical)

In GA4: **Reports → Engagement → Events** shows counts per event. Create a
**Conversion** from `cta_use_template` (Admin → Events → mark as key event) to
track your main goal over time.

### Isolating AI-referral traffic (the GEO payoff)

To see visits sent by AI engines (the point of Phase 2): GA4 → **Explore** →
free-form, dimension **Session source / medium**, and filter for hosts like
`chatgpt.com`, `perplexity.ai`, `gemini.google.com`, `copilot.microsoft.com`.
That's how you'll know the structured-data/llms.txt work is paying off.

## Turning it on (owner step)

1. Create a GA4 property → copy its **Measurement ID** (`G-XXXXXXXXXX`).
2. In `src/config.yaml`, set `analytics.vendors.googleAnalytics.id` to that ID.
   (It's `null` in the repo on purpose — **never commit a real ID to a public
   repo if you consider it sensitive**; for GA4 the Measurement ID is public by
   design, but keep it in your own fork.)
3. Deploy. Consent Mode v2 (default-denied) and event tracking activate
   automatically. Add a consent banner/CMP if you want visitors to opt in.

## Conversion fundamentals (already in place + honest notes)

- **Primary CTA** ("Use this template") is above the fold with action language;
  a **secondary CTA** ("How it works") serves a different journey stage. Both
  were set in the content rebrand.
- **Benefit-led headlines** (keyless, ~$0/month, ~40 min to deploy) — all real,
  verifiable facts.
- **Form**: minimal fields with associated labels (Phase 4). Note: the demo
  contact form has **no backend** — wire it to your handler before relying on it.

## Where REAL trust signals come from (no fabrication)

You asked where to get real social-proof data. For an open-source project, the
**real, live** sources are:

- **GitHub stars / forks** — live via the badge in the announcement bar
  (`shields.io`), and on your repo page. These are genuine social proof.
- **Your real Lighthouse score** — run PageSpeed Insights on your live URL and
  publish the number/badge once it's real.
- **Testimonials** — collect actual quotes from real users (GitHub issues,
  Discussions, X) and add them with attribution. **Do not invent them.**
- **Usage facts** — the `~$0/month`, `0 keys`, `~40 min` stats on the homepage
  are real and defensible.

## No dark patterns (commitment)

No fake urgency, no countdowns, no fabricated scarcity, no invented reviews.
Conversion here comes from clarity, speed, trust, and reduced friction — which
is also what the earlier phases optimized.
