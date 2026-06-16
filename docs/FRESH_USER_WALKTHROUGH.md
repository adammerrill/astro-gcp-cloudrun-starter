# Fresh User Walkthrough — Zero to Deployed

The single authoritative path from a clean GCP account to a live, public Cloud
Run URL deployed keylessly from GitHub Actions. Follow it top to bottom. All
real values stay in git-ignored files; only placeholders appear here.

**Estimated active time:** ~30–45 minutes. **Cost:** ≈ $0/month (scale-to-zero,
free-tier-sized; a `$5` budget alert is created automatically).

Throughout, replace `PREFIX` with your chosen short, lowercase project prefix
(e.g. `acme`). Projects will be named `PREFIX-shared`, `PREFIX-dev`, etc.
GCP project IDs max out at 30 chars, so keep `PREFIX` ≤ ~20 chars.

---

## 0. Prerequisites

| Requirement                                                    | Check                             |
| -------------------------------------------------------------- | --------------------------------- |
| `gcloud` CLI                                                   | `gcloud --version`                |
| Terraform ≥ 1.5                                                | `terraform --version`             |
| `git` + `gh` CLI                                               | `git --version` && `gh --version` |
| Docker (for local image build)                                 | `docker --version`                |
| A GCP **billing account** (note its ID `XXXXXX-XXXXXX-XXXXXX`) | GCP Console → Billing             |
| Permission to create projects on that billing account          | (Owner/Billing Admin)             |

> **New billing accounts have a project-creation quota.** The bootstrap creates
> 4 projects (`shared`, `dev`, `staging`, `prod`). If you hit
> `Cloud billing quota exceeded`, either request a quota increase, or create
> fewer projects for now (a demo only needs `shared` + `dev` — remove the
> unneeded `google_project` resources/outputs from `terraform/bootstrap/`).

## 1. Instantiate & authenticate

```bash
# Use this repo as a GitHub template (or clone your copy), then:
git clone https://github.com/YOUR_GITHUB_OWNER/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME

# Keyless local auth — NEVER download a service-account JSON key.
gcloud auth login
gcloud auth application-default login
```

## 2. Bootstrap the GCP foundation (creates projects, state bucket, admin SA)

```bash
cp terraform/bootstrap/terraform.tfvars.example terraform/bootstrap/terraform.tfvars
# Edit it: project_prefix, billing_account_id, developer_email, region
cd terraform/bootstrap
terraform init
terraform apply        # review plan, type yes  (~2–3 min)
```

This creates the projects, the GCS state bucket `PREFIX-tf-state`, the
`sa-terraform-admin` automation SA, and enables the seed APIs (including
`iamcredentials` and `cloudbilling`, which all later steps depend on).

**Migrate bootstrap state into GCS:**

```bash
cp backend.tf.example backend.tf
# Edit backend.tf: set bucket = "PREFIX-tf-state"
terraform init -migrate-state    # type yes to copy state to GCS
```

## 3. Apply the shared layer (WIF, deploy SA, Artifact Registry)

```bash
cd ../environments/shared
cp terraform.tfvars.example terraform.tfvars   # fill in (incl. github_repo!)
cp backend.tf.example backend.tf               # set bucket = "PREFIX-tf-state"
terraform init
terraform apply        # type yes

# Capture these outputs — you need them for the GitHub Variables in step 5:
terraform output wif_provider_name            # → WIF_PROVIDER
terraform output deploy_service_account_email # → SA_DEPLOY
terraform output ar_repository_url            # → AR_REGION / SHARED_PROJECT / AR_REPO
```

> `create_project` defaults to **false** in env layers because the bootstrap
> already created the projects — Terraform adopts them. Do not set it true.

## 4. Apply the dev layer (Cloud Run + supporting infra)

```bash
cd ../dev
cp terraform.tfvars.example terraform.tfvars   # fill in your values
cp backend.tf.example backend.tf               # set bucket = "PREFIX-tf-state", prefix = "dev"
terraform init
terraform apply        # type yes  (~3–5 min)
```

This creates the Cloud Run service (placeholder image), IAM, monitoring,
logging, and the `$5` billing budget. It also grants the **deploy SA**
`run.developer` + `serviceAccountUser` here, and the env Cloud Run **service
agent** read access to the shared Artifact Registry — so CI can deploy.

## 5. Configure GitHub Actions Variables

Deploys are keyless (WIF) — **no GitHub Secrets are needed**. Set these as
repository or `dev`-environment **Variables**. Three come from the shared
outputs (step 3); the rest you already know.

| Variable             | Value                                           |
| -------------------- | ----------------------------------------------- |
| `WIF_PROVIDER`       | shared output `wif_provider_name`               |
| `SA_DEPLOY`          | shared output `deploy_service_account_email`    |
| `AR_REGION`          | region, e.g. `us-central1`                      |
| `SHARED_PROJECT`     | `PREFIX-shared`                                 |
| `AR_REPO`            | `website`                                       |
| `SERVICE_NAME`       | `website` (MUST equal Terraform `service_name`) |
| `REGION`             | region, e.g. `us-central1`                      |
| `PROJECT_ID`         | `PREFIX-dev`                                    |
| `PROJECT_PREFIX`     | `PREFIX`                                        |
| `TF_STATE_BUCKET`    | `PREFIX-tf-state`                               |
| `BILLING_ACCOUNT_ID` | `XXXXXX-XXXXXX-XXXXXX`                          |

```bash
# Example (repeat per variable); use --env dev to scope to the dev Environment:
gh variable set SERVICE_NAME --env dev --body "website" --repo YOUR_GITHUB_OWNER/YOUR_REPO_NAME
gh variable list --env dev --repo YOUR_GITHUB_OWNER/YOUR_REPO_NAME
```

> Create the `dev` Environment first (Settings → Environments → New) if you use
> `--env dev`. On `prod` you can add required reviewers for a deploy gate.

## 6. Deploy & verify

```bash
# Build locally once to be sure the image is healthy:
npm install && npm run build && docker build -t website:local .
```

Push to `main` (or merge a PR). The `Deploy Dev` workflow builds the image,
pushes it to Artifact Registry, deploys a new Cloud Run revision, and smoke-
tests the URL. Then confirm:

```bash
gcloud run services describe website \
  --region=us-central1 --project=PREFIX-dev \
  --format='value(status.url)'
```

Open the printed URL — your Astro site is live and public.

---

## Order summary (prerequisites → live URL)

```
prereqs → gcloud auth → bootstrap apply → migrate state to GCS
        → shared apply (capture outputs) → dev apply
        → set 11 GitHub Variables → push to main → verify URL
```

## Cost & safety defaults (already configured)

`min_instances=0` (scale to zero) · `max_instances=2` (runaway cap) ·
`0.5` vCPU / `256Mi` · no VPC connector / Cloud SQL / LB · single region ·
`$5` budget with 50/80/100% email alerts. Expect ≈ $0/month (estimate;
re-verify current free-tier figures on Google's pricing page).
