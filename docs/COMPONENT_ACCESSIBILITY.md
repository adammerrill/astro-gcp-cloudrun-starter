# Phase 4 — Component-Structure Hardening (plain-language guide)

Correct, accessible HTML structure helps assistive technology **and** machines
(crawlers/LLMs) understand the page, and shipping minimal JavaScript keeps
interactions fast (low INP). This phase audited those and fixed the one real gap.

## What changed

### Skip-to-content link (WCAG 2.2 SC 2.4.1, Bypass Blocks)

Added a "Skip to main content" link as the **first focusable element** on the
page. It's invisible until a keyboard user presses Tab, then appears and lets
them jump **past the navigation** straight to the main content (`<main id="main">`).
Without it, keyboard and screen-reader users must tab through every nav link on
every page. Source: [W3C: Bypass Blocks](https://www.w3.org/WAI/WCAG22/Understanding/bypass-blocks.html).

## What was audited and already correct (verified, not assumed)

The template was already well-structured here — these were checked and left as-is:

| Area                 | Finding                                                                                                                 |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Landmarks**        | `<header>`, `<nav>`, `<main>`, `<footer>` all present and correct                                                       |
| **Headings**         | Hero renders one `<h1>`; section headlines use `<h2>` — logical order                                                   |
| **Buttons vs links** | `Button.astro` renders a real `<button>` for `type=button/submit/reset` and an `<a>` otherwise — correct semantics      |
| **Form labels**      | Every input/textarea/checkbox has an associated `<label for>` matching its `id`                                         |
| **Focus visibility** | Controls that use `focus:outline-none` always pair it with `focus:ring-4`, so keyboard focus stays visible (WCAG 2.4.7) |
| **Images**           | The `<Image />` component **requires** `alt` (throws at build if missing); decorative images pass `alt=""`              |
| **Language**         | `<html lang>` is set from config                                                                                        |

### Minimal hydration (low INP)

**Zero** Astro "islands" are hydrated (`grep` for `client:*` → none). The only
JavaScript module shipped site-wide is the View Transitions runtime (~16 KB).
Less JavaScript on the main thread = faster response to clicks/taps = lower INP.
This is already optimal; nothing to trim without removing View Transitions
(an option flagged in Phase 1, not done).

## Manual verification (browser — do once)

A few structural checks need a real browser/AT and are listed here rather than
claimed done from a headless environment:

1. **Keyboard-only pass:** load the homepage, press **Tab** once — the "Skip to
   main content" link should appear; activate it and confirm focus lands in the
   main content. Then Tab through the whole page and confirm every interactive
   element shows a **visible focus ring** and nothing is a keyboard trap.
2. **Screen reader spot-check** (VoiceOver/NVDA): confirm landmarks (banner,
   navigation, main, contentinfo) are announced and headings form an outline.
3. **Reduced motion:** with the OS "reduce motion" setting on (added in Phase 3),
   confirm animations don't play.
