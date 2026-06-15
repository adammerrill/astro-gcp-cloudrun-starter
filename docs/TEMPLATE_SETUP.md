# TEMPLATE QUICKSTART: Using this Starter Template

Welcome to the Google Cloud Run Web Application Starter Template! This repository is configured as a zero-secrets, reusable template for standing up any containerized web application on Google Cloud Platform (GCP) with Terraform.

---

## Onboarding Steps

### 1. Instantiate the Repository
Click **"Use this template"** on GitHub (or clone/branch the repository) to create your own copy of this codebase.

### 2. Copy and Customize Config Files
Every environment-specific or sensitive configuration file is git-ignored. You must copy each `.example` template to its real counterpart and fill in your details:

| Target Location | Example Template Source | Description |
|:---|:---|:---|
| `terraform/bootstrap/terraform.tfvars` | `terraform/bootstrap/terraform.tfvars.example` | Naming prefix, developer email, and billing account details for bootstrapping the GCP projects. |
| `terraform/environments/shared/terraform.tfvars` | `terraform/environments/shared/terraform.tfvars.example` | Parameters for global WIF OIDC and Artifact Registry. |
| `terraform/environments/shared/backend.tf` | `terraform/environments/shared/backend.tf.example` | GCS state backend settings for the shared environment. |
| `terraform/environments/dev/terraform.tfvars` | `terraform/environments/dev/terraform.tfvars.example` | Dev environment cost ceilings and settings. |
| `terraform/environments/dev/backend.tf` | `terraform/environments/dev/backend.tf.example` | GCS state backend settings for the dev environment. |
| `terraform/environments/staging/terraform.tfvars` | `terraform/environments/staging/terraform.tfvars.example` | Staging environment settings. |
| `terraform/environments/staging/backend.tf` | `terraform/environments/staging/backend.tf.example` | GCS state backend settings for the staging environment. |
| `terraform/environments/production/terraform.tfvars` | `terraform/environments/production/terraform.tfvars.example` | Production HA environment settings. |
| `terraform/environments/production/backend.tf` | `terraform/environments/production/backend.tf.example` | GCS state backend settings for the production environment. |

### 3. Bootstrap your GCP Foundation
Follow the instructions in the [Setup Playbook](./SETUP_PLAYBOOK.md) to log in locally with `gcloud`, run the bootstrap module to spawn your projects and SA, and migrate your state to GCS.

### 4. Replace the Scaffold Application
The `/app/` directory contains a placeholder Node.js server. Replace the files in `/app/` with your real web application (Next.js, FastAPI, Go, etc.). Ensure your Dockerfile compiles successfully and exposes a web server listening on the `$PORT` environment variable.
