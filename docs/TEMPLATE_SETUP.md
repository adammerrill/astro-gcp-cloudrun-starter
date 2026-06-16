# TEMPLATE QUICKSTART: Using this Starter Template

Welcome to the Google Cloud Run Web Application Starter Template! This repository is configured as a zero-secrets, reusable template for standing up any containerized web application on Google Cloud Platform (GCP) with Terraform.

---

## Onboarding Steps

### 1. Instantiate the Repository

Click **"Use this template"** on GitHub (or clone/branch the repository) to create your own copy of this codebase.

### 2. Copy and Customize Config Files

Every environment-specific or sensitive configuration file is git-ignored. You must copy each `.example` template to its real counterpart and fill in your details:

| Target Location                                      | Example Template Source                                      | Description                                                                                     |
| :--------------------------------------------------- | :----------------------------------------------------------- | :---------------------------------------------------------------------------------------------- |
| `terraform/bootstrap/terraform.tfvars`               | `terraform/bootstrap/terraform.tfvars.example`               | Naming prefix, developer email, and billing account details for bootstrapping the GCP projects. |
| `terraform/environments/shared/terraform.tfvars`     | `terraform/environments/shared/terraform.tfvars.example`     | Parameters for global WIF OIDC and Artifact Registry.                                           |
| `terraform/environments/shared/backend.tf`           | `terraform/environments/shared/backend.tf.example`           | GCS state backend settings for the shared environment.                                          |
| `terraform/environments/dev/terraform.tfvars`        | `terraform/environments/dev/terraform.tfvars.example`        | Dev environment cost ceilings and settings.                                                     |
| `terraform/environments/dev/backend.tf`              | `terraform/environments/dev/backend.tf.example`              | GCS state backend settings for the dev environment.                                             |
| `terraform/environments/staging/terraform.tfvars`    | `terraform/environments/staging/terraform.tfvars.example`    | Staging environment settings.                                                                   |
| `terraform/environments/staging/backend.tf`          | `terraform/environments/staging/backend.tf.example`          | GCS state backend settings for the staging environment.                                         |
| `terraform/environments/production/terraform.tfvars` | `terraform/environments/production/terraform.tfvars.example` | Production HA environment settings.                                                             |
| `terraform/environments/production/backend.tf`       | `terraform/environments/production/backend.tf.example`       | GCS state backend settings for the production environment.                                      |

### 3. Bootstrap your GCP Foundation

Follow the instructions in the [Setup Playbook](./SETUP_PLAYBOOK.md) to log in locally with `gcloud`, run the bootstrap module to spawn your projects and SA, and migrate your state to GCS. For the complete, ordered path from zero to a live URL, use the [Fresh User Walkthrough](./FRESH_USER_WALKTHROUGH.md).

### 4. Customize the Application

This template **is** the application — an [Astro](https://astro.build/) static site at the repository root. There is no separate `/app/` server.

- Source lives in `src/` (pages, components, content); site config is `src/config.yaml`.
- The root **`Dockerfile`** is the build contract: it builds the static site with Node 22 (`npm run build` → `dist/`) and serves it with **nginx on port 8080** (the port Cloud Run sends traffic to). You do not need a `$PORT`-listening Node server.
- To use a different framework, replace the source and update the root `Dockerfile`, keeping the container listening on **8080**.

Verify your build locally before deploying:

```bash
npm install
npm run build          # produces dist/
docker build -t website:local .   # must succeed
```

### 5. Wire up CI/CD (GitHub Actions Variables)

Deploys run keylessly via Workload Identity Federation — there are **no secrets** to store. After the shared layer is applied, set the GitHub Actions **Variables** (not Secrets) that the deploy workflow reads. The exact list, values, and `gh` commands are in the [Fresh User Walkthrough](./FRESH_USER_WALKTHROUGH.md#5-configure-github-actions-variables).
