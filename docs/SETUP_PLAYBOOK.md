# SETUP PLAYBOOK: Standing Up the GCP Environment

This playbook guides a developer to stand up the web application on Google Cloud Platform (GCP) with infrastructure managed as code using Terraform.

Our governing principle is **Terraform Maximalism**: Terraform does the maximum. The GCP Console and gcloud CLI are used **only** for the irreducible seed bootstrap steps that genuinely cannot be done by Terraform (since they must exist before Terraform can run). All subsequent configuration (APIs, IAM, Cloud Run, Cloud SQL, Secret Manager, WIF, etc.) is fully managed by Terraform, reviewed via PR, and applied in CI/CD.

---

## Part 1: Irreducible Seed Manual Setup (M-1 to M-5)

These steps are done exactly **once** by a human operator with sufficient organization-level or billing-level permissions.

### M-1: Authenticate Locally
Authenticate your local shell to GCP to generate Application Default Credentials (ADC). This allows local Terraform execution to run under your developer identity. **Do not download or create JSON service account keys.**

```bash
# Authenticate gcloud CLI
gcloud auth login

# Set Application Default Credentials (ADC) for Terraform
gcloud auth application-default login
```

### M-2: Set Developer Variables
Ensure you have the following information before proceeding:
- **Billing Account ID**: e.g., `012345-6789AB-CDEF01`
- **Developer Email**: your GCP user account email, e.g., `developer@example.com`
- **Project Prefix**: name identifier for resources, default is `mortru`
- **Region**: default is `us-central1`

---

## Part 2: Two-Stage Bootstrap Migration (Phase 1)

Terraform must initialize using local state to create the target projects and GCS state bucket, and then migrate its state file into the newly created GCS bucket.

### Step 1: Configure Bootstrap Variables
Open `terraform/bootstrap/terraform.tfvars` and update the placeholders with your values:
```hcl
project_prefix     = "mortru"
billing_account_id = "012345-6789AB-CDEF01" # Update with your real billing account ID
developer_email    = "developer@example.com"  # Update with your developer email
region             = "us-central1"
```

### Step 2: Apply Bootstrap (Local State)
Change directory to `terraform/bootstrap/` and initialize and apply the bootstrap configuration.
```bash
cd terraform/bootstrap

# Initialize with local state backend
terraform init

# Apply the bootstrap plan
terraform apply
```
*This step creates the four projects (`mortru-shared`, `mortru-dev`, `mortru-staging`, `mortru-prod`), enables seed APIs, creates the GCS state bucket (`mortru-tf-state`), creates the automation service account (`sa-terraform-admin`), and grants you permission to impersonate it.*

### Step 3: Configure GCS Backend & Migrate State
Once the GCS state bucket has been created, add the GCS backend configuration block to `terraform/bootstrap/main.tf` to point to GCS:
```hcl
# Add this block inside the terraform {} configuration block in terraform/bootstrap/main.tf
  backend "gcs" {
    bucket = "mortru-tf-state" # Replace with your project_prefix-tf-state
    prefix = "bootstrap"
  }
```
Run `terraform init` to migrate your local state:
```bash
terraform init -migrate-state
```
Confirm `yes` when prompted to copy local state into the GCS bucket.
Verify that the local state file `terraform.tfstate` is now empty or can be safely deleted (and is gitignored).

---

## Part 3: Deploying Environments (Dev / Staging / Production)

All downstream environments use **Service Account Impersonation**. They authenticate through local ADC but execute all API actions as the privileged `sa-terraform-admin` service account.

### Step 1: Verify Environment Configurations
Before applying, ensure `terraform.tfvars` in the target environment (e.g., `terraform/environments/dev/terraform.tfvars`) has the correct parameters:
```hcl
billing_account_id        = "012345-6789AB-CDEF01"
terraform_service_account = "sa-terraform-admin@mortru-shared.iam.gserviceaccount.com"
# ... other vars
```

### Step 2: Initialize and Apply
Change to the environment directory and run Terraform.
```bash
cd terraform/environments/dev

# Initialize the environment backend
terraform init

# Plan the environment resources
terraform plan

# Apply the environment resources
terraform apply
```
