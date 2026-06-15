#!/usr/bin/env bash
set -euo pipefail

# Teardown script for a specific environment

if [ $# -lt 1 ]; then
    echo "Usage: $0 <environment>"
    echo "Example: $0 dev"
    exit 1
fi

ENV=$1

echo "WARNING: You are about to DESTROY all resources in the '${ENV}' environment!"
echo "This action is irreversible and will delete the project, Cloud Run services, monitoring dashboards, databases, and more."
read -rp "Are you absolutely sure you want to proceed? Type 'DESTROY' to confirm: " CONFIRM

if [ "$CONFIRM" != "DESTROY" ]; then
    echo "Teardown cancelled."
    exit 0
fi

echo "Proceeding with teardown of ${ENV}..."

# Change to the environment directory and destroy
ENV_DIR="$(dirname "$0")/../terraform/environments/${ENV}"
if [ -d "$ENV_DIR" ]; then
    cd "$ENV_DIR"
    terraform init
    terraform destroy -auto-approve
else
    echo "Error: Environment directory ${ENV_DIR} does not exist."
    exit 1
fi

echo "Teardown of ${ENV} completed successfully."
