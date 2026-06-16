# Phase 2 — GEO / LLM Indexing & Structured Data (plain-language guide)

This phase makes the site **findable, understandable, and citable by AI search
engines** (ChatGPT, Claude, Gemini, Perplexity, Google AI Overviews) and by
traditional search.

## Jargon, defined once

- **GEO (Generative Engine Optimization)** — structuring content so AI engines
  can extract clean, verifiable facts and **cite your site** in their answers.
  Anchored in the academic paper "GEO: Generative Engine Optimization"
  (Aggarwal et al., Carnegie Mellon, KDD 2024).
- **schema.org** — a shared vocabulary of "types" (Organization, FAQPage,
  BlogPosting…) that describe what a page is about, in a way machines parse
  reliably. See [schema.org](https://schema.org).
- **JSON-LD** — the format Google recommends for schema.org: a small block of
  JSON in the page that states the facts explicitly. See
  [Google: intro to structured data](https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data).
- **llms.txt** — a proposed markdown file at `/llms.txt` that gives AI models a
  curated index of your most important content. See [llmstxt.org](https://llmstxt.org/).

## What changed in this phase

### 1. schema.org JSON-LD on every page (config-driven)

All schema is built in **one place** (`src/utils/schema.ts`) from the site
config — never hardcoded in individual components — and injected via
`src/components/common/StructuredData.astro`.

| Page       | Schema types emitted                                 | Why                                                                   |
| ---------- | ---------------------------------------------------- | --------------------------------------------------------------------- |
| Every page | `Organization`, `WebSite`                            | Establishes the brand/site identity sitewide                          |
| Homepage   | + `SoftwareApplication`, `FAQPage`, `BreadcrumbList` | Declares it's a free dev tool; exposes each FAQ as an extractable Q&A |
| Blog posts | + `BlogPosting`, `BreadcrumbList`                    | Makes each article a clean, attributable source with author/date      |

**Why multiple types matters:** the CMU GEO research found that pages exposing
richer, well-structured, verifiable facts earn more citations in AI answers.
A page with several valid schema types gives engines more to work with.

**The FAQ is now a single source of truth:** the homepage FAQ list is defined
once and used **both** for the on-page accordion **and** the `FAQPage` schema —
so what users read and what machines extract can never drift apart.

### 2. Definition-first, fact-dense content

GEO research shows the **first ~150 tokens** of a page carry disproportionate
weight in AI retrieval. Key pages now open with a **definition-first sentence**
("astro-gcp-cloudrun-starter is a … template that …") and use specific,
verifiable facts (e.g. "min-instances = 0", "~$0/month", "port 8080") instead
of vague claims — because LLMs prefer quotable, checkable statements.

### 3. `/llms.txt`

A new `public/llms.txt` gives AI systems a curated, markdown index: a one-line
definition, key facts, and links to the documentation. It **complements**
`robots.txt` (which controls access) and `sitemap.xml` (which lists URLs) — it
does not replace them.

## Content integrity (important)

Every fact in the schema and `llms.txt` is **real and verifiable** — the MIT
license, the free/open-source price (`0`), the GitHub repository, the cost and
port facts. We deliberately did **not** add `aggregateRating`/review schema,
because that would require fabricating ratings the project doesn't have. Putting
false facts in schema is worse than none — an AI engine could cite them.

## How to verify after deploy (do this once live)

1. **Google Rich Results Test** — paste your live URL at
   [search.google.com/test/rich-results](https://search.google.com/test/rich-results).
   It should detect FAQ, Breadcrumbs, and the other types with **no errors**.
2. **Schema Markup Validator** — [validator.schema.org](https://validator.schema.org/)
   for full schema.org validation.
3. **View source** on any page and search for `application/ld+json` — you'll see
   the blocks. (Locally verified: homepage = 5 blocks, blog post = 4 blocks,
   all valid JSON.)
4. Visit **`/llms.txt`** on your domain to confirm it serves.
