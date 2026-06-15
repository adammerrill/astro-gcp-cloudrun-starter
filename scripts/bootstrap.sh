#!/usr/bin/env bash
set -euo pipefail

# Bootstrap script to initialize the Google Cloud Shared project and GCS bucket for Terraform state.

PROJECT_PREFIX="mortru"
BILLING_ACCOUNT_ID=""
REGION="us-central1"
SHARED_PROJECT_ID="${PROJECT_PREFIX}-shared"
STATE_BUCKET_NAME="${PROJECT_PREFIX}-tf-state"

echo "=== Google Cloud Architecture Bootstrap ==="

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "Error: gcloud CLI is not installed. Please install it first."
    exit 1
fi

# Authenticate if needed
echo "Checking gcloud authentication..."
if ! gcloud auth list --filter=status=ACTIVE --format="value(account)" | grep -q "@"; then
    echo "No active gcloud session found. Launching login..."
    gcloud auth login
fi

# Get Billing Account ID
if [ -z "$BILLING_ACCOUNT_ID" ]; then
    echo "Retrieving billing accounts..."
    gcloud beta billing accounts list
    read -rp "Enter your Billing Account ID: " BILLING_ACCOUNT_ID
fi

# Create shared project
echo "Creating shared project ${SHARED_PROJECT_ID}..."
if gcloud projects describe "${SHARED_PROJECT_ID}" &>/dev/null; then
    echo "Project ${SHARED_PROJECT_ID} already exists."
else
    gcloud projects create "${SHARED_PROJECT_ID}" --name="Mortru Shared"
fi

# Link billing account
echo "Linking billing account ${BILLING_ACCOUNT_ID} to ${SHARED_PROJECT_ID}..."
gcloud beta billing projects link "${SHARED_PROJECT_ID}" --billing-account="${BILLING_ACCOUNT_ID}"

# Enable Service Usage API
echo "Enabling Service Usage API on ${SHARED_PROJECT_ID}..."
gcloud services enable serviceusage.googleapis.com --project="${SHARED_PROJECT_ID}"

# Enable basic APIs needed to create the GCS bucket
echo "Enabling Storage API on ${SHARED_PROJECT_ID}..."
gcloud services enable storage.googleapis.com --project="${SHARED_PROJECT_ID}"

# Create the TF state bucket
echo "Creating GCS state bucket gs://${STATE_BUCKET_NAME} in ${REGION}..."
if gcloud storage buckets describe "gs://${STATE_BUCKET_NAME}" --project="${SHARED_PROJECT_ID}" &>/dev/null; then
    echo "Bucket gs://${STATE_BUCKET_NAME} already exists."
else
    gcloud storage buckets create "gs://${STATE_BUCKET_NAME}" \
        --project="${SHARED_PROJECT_ID}" \
        --location="${REGION}" \
        --uniform-bucket-level-access
fi

echo "=== Bootstrap Completed Successfully ==="
echo "Shared Project: ${SHARED_PROJECT_ID}"
echo "State Bucket: gs://${STATE_BUCKET_NAME}"
echo ""
echo "Next steps:"
echo "1. Update terraform.tfvars files in environments/shared, dev, staging, production."
echo "2. Run terraform init && terraform apply in environments/shared."
