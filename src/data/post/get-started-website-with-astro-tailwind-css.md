---
publishDate: 2026-06-16T00:00:00Z
author: astro-gcp-cloudrun-starter
title: Deploy this template to Google Cloud Run — keyless and cost-optimized
excerpt: A walkthrough of standing up the Astro + GCP Cloud Run starter — keyless Workload Identity Federation, Terraform layers, and a scale-to-zero demo that costs ~$0/month.
image: https://images.unsplash.com/photo-1451187580459-43490279c0fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=2072&q=80
category: Guides
tags:
  - gcp
  - cloud run
  - terraform
  - workload identity federation
metadata:
  canonical: https://github.com/adammerrill/astro-gcp-cloudrun-starter
---

This template takes an Astro v6 + Tailwind CSS v4 site from a public GitHub repo to a live, public **Google Cloud Run** URL — with **no service-account keys anywhere** and a cost profile of roughly **$0/month**. This post is the short version of the [Fresh User Walkthrough](https://github.com/adammerrill/astro-gcp-cloudrun-starter/blob/main/docs/FRESH_USER_WALKTHROUGH.md).

## The core idea: keyless and zero-secrets

Because the repository is public, the guiding rule is that **nothing sensitive ever enters it** — not files, not history, not CI logs. Two design choices make that possible:

- **Workload Identity Federation (WIF):** GitHub Actions presents an OIDC token that GCP exchanges for a short-lived credential at deploy time. There is no long-lived JSON key to leak, and the WIF provider is scoped to **this exact repository**, so no other repo — even under the same account — can assume the deploy identity.
- **Secrets stay out of git:** identity is keyless, and any real runtime secret lives in Google Secret Manager (injected into Cloud Run). Only placeholder `.example` files are committed; real values live in GitHub Actions **Variables** and your untracked `terraform.tfvars`.

## The Terraform layers

Infrastructure is provisioned in three ordered layers, all in Terraform with state in GCS:

1. **Bootstrap** (one-time seed): creates the GCP projects, the GCS state bucket, and an automation service account, then migrates its own state into GCS.
2. **Shared:** the WIF pool/provider, the GitHub deploy service account, and the Artifact Registry that every environment pulls images from.
3. **Environment** (`dev` / `staging` / `prod`): adopts its bootstrap-created project and stands up Cloud Run, IAM, monitoring, logging, and a billing budget.

## The deploy flow

Once the GitHub Actions Variables are set from your Terraform outputs:

```
push to main → GitHub Actions authenticates via WIF → builds the Astro container
→ pushes to Artifact Registry → deploys a new Cloud Run revision → smoke-tests the URL
```

The pipeline is **app-deploy-only**: it ships images but cannot modify infrastructure, keeping the deploy identity least-privilege. Terraform is run deliberately, from a controlled environment.

## Why it stays at ~$0/month

- **Scale to zero:** `min-instances = 0`, so an idle service isn't billed. The trade-off is a sub-2-second cold start on the first request after idle — fine for a demo.
- **Sized small and capped:** the smallest sensible CPU/memory plus a low `max-instances` cap means a public URL anyone can hit can't autoscale into a surprise bill.
- **Free tier + budget alert:** a low-traffic static site stays within Cloud Run's perpetual free tier, and a per-project billing budget alerts at 50/80/100% as a backstop.

> Treat the cost figure as an estimate, not a guarantee — model your own traffic with the GCP pricing calculator and re-check current free-tier limits on Google's pricing page.

## Use your own framework

The Astro site is just the default payload. The root `Dockerfile` is the real contract: build your app and serve it on **port 8080**. Swap the source and the build steps, and the Terraform foundation and CI carry over unchanged.

Ready to try it? Head to the [repository](https://github.com/adammerrill/astro-gcp-cloudrun-starter) and click **Use this template**.
