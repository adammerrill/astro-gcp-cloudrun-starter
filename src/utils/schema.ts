/**
 * schema.org JSON-LD builders (GEO / structured data).
 *
 * Why: AI search engines (ChatGPT, Claude, Perplexity, Google AI Overviews) and
 * traditional search extract clean, verifiable facts from schema.org JSON-LD to
 * decide what a page is about and whether to cite it. Pages exposing multiple
 * valid schema types are more citable (CMU "GEO", KDD 2024; schema.org; Google
 * structured-data docs).
 *
 * All values come from this central constants/config layer — never hardcoded
 * per component. Only real, verifiable facts are included (no fabricated
 * ratings or reviews).
 */
import { SITE, METADATA } from 'astrowind:config';

// --- Verifiable project constants -------------------------------------------
const REPO_URL = 'https://github.com/adammerrill/astro-gcp-cloudrun-starter';
const LICENSE_URL = 'https://opensource.org/licenses/MIT';
const ORG_NAME: string = SITE?.name ?? 'astro-gcp-cloudrun-starter';
const SITE_URL: string = SITE?.site ?? '';
const DESCRIPTION: string = METADATA?.description ?? '';

const abs = (path = '/'): string => (SITE_URL ? new URL(path, SITE_URL).toString() : path);
const iso = (d?: Date | string): string | undefined => (d ? new Date(d).toISOString() : undefined);

type Json = Record<string, unknown>;

export interface FaqItem {
  title: string;
  description: string;
}

export interface CrumbItem {
  name: string;
  url: string;
}

export interface PostLike {
  title: string;
  excerpt?: string;
  image?: unknown;
  publishDate?: Date | string;
  updateDate?: Date | string;
  author?: string;
}

export const getOrganizationSchema = (): Json => ({
  '@context': 'https://schema.org',
  '@type': 'Organization',
  '@id': abs('/#organization'),
  name: ORG_NAME,
  url: abs('/'),
  description: DESCRIPTION,
  sameAs: [REPO_URL],
});

export const getWebSiteSchema = (): Json => ({
  '@context': 'https://schema.org',
  '@type': 'WebSite',
  '@id': abs('/#website'),
  name: ORG_NAME,
  url: abs('/'),
  description: DESCRIPTION,
  inLanguage: 'en',
  publisher: { '@id': abs('/#organization') },
});

export const getSoftwareApplicationSchema = (): Json => ({
  '@context': 'https://schema.org',
  '@type': 'SoftwareApplication',
  name: ORG_NAME,
  description: DESCRIPTION,
  url: abs('/'),
  applicationCategory: 'DeveloperApplication',
  operatingSystem: 'Google Cloud Run (containerized; any platform)',
  offers: { '@type': 'Offer', price: '0', priceCurrency: 'USD' },
  license: LICENSE_URL,
  isAccessibleForFree: true,
  codeRepository: REPO_URL,
});

export const getFAQSchema = (items: FaqItem[]): Json => ({
  '@context': 'https://schema.org',
  '@type': 'FAQPage',
  mainEntity: items.map((i) => ({
    '@type': 'Question',
    name: i.title,
    acceptedAnswer: { '@type': 'Answer', text: i.description },
  })),
});

export const getArticleSchema = (post: PostLike, url: string): Json => ({
  '@context': 'https://schema.org',
  '@type': 'BlogPosting',
  headline: post.title,
  description: post.excerpt,
  url,
  mainEntityOfPage: url,
  datePublished: iso(post.publishDate),
  dateModified: iso(post.updateDate) ?? iso(post.publishDate),
  author: { '@type': 'Person', name: post.author ?? ORG_NAME },
  publisher: { '@id': abs('/#organization') },
  ...(typeof post.image === 'string' ? { image: post.image } : {}),
});

export const getBreadcrumbSchema = (items: CrumbItem[]): Json => ({
  '@context': 'https://schema.org',
  '@type': 'BreadcrumbList',
  itemListElement: items.map((it, idx) => ({
    '@type': 'ListItem',
    position: idx + 1,
    name: it.name,
    item: it.url,
  })),
});

export { abs as absoluteUrl };
