# INFRASTRUCTURE AS CODE (IaC) GOVERNANCE RULES

Every developer working on this project must strictly follow these rules to ensure the GCP infrastructure remains fully reproducible, secure, and audited.

---

### RULE 1 — Manual is only the seed

The GCP Console and `gcloud` CLI are touched **only** for the irreducible setup steps (M-1 to M-5) defined in the Setup Playbook. After the bootstrap is run, any and all changes to GCP infrastructure must be made by editing Terraform files and opening a PR. No manual modifications (click-ops) are allowed in the GCP console.

### RULE 2 — No keys

Authenticate using local Application Default Credentials (ADC) and Service Account Impersonation locally, and Workload Identity Federation (WIF) in CI/CD. **Never create, download, or commit a service account JSON key.** Key creation is blocked by organization policy wherever possible.

### RULE 3 — No hardcoded values

Project IDs, billing account IDs, regions, image tags, service account emails, and secrets must **never** be hardcoded in resource blocks. Use variables, `terraform.tfvars`, and outputs. Secrets must only be stored in Secret Manager and referenced as configuration metadata.

### RULE 4 — State is sacred

Always use a GCS backend with a unique prefix per environment/stack. Never commit a `.tfstate` or `.tfstate.backup` file (ensure they are in `.gitignore`). Never edit state files by hand. Only run `terraform force-unlock` after confirming no other execution is active.

### RULE 5 — Plan before apply, PR before merge

Every infrastructure change must follow the branch workflow:

1. Create a feature branch.
2. Verify formatting and validate changes.
3. Run `terraform plan` in the Pull Request.
4. Obtain human review.
5. Merge to `main`.
6. Allow the CI/CD pipeline to execute `terraform apply`. Never run `apply` directly from a local machine on production.

### RULE 6 — Least privilege

Runtime service accounts (e.g., Cloud Run runner) must only be granted the specific, narrow roles they require. Never grant primitive roles (`roles/owner`, `roles/editor`) to runtime identities. All database configurations must use private IP connectivity and firewall defaults must be set to deny-all.

### RULE 7 — Drift is a bug

If the GCP Console shows a resource or configuration that is not defined in Terraform, that is considered a bug (infrastructure drift). Reconcile it immediately by either importing the resource into Terraform or deleting it. Never "fix it" in the Console.

### RULE 8 — Everything reproducible

The setup process must be completely self-contained. A new engineer must be able to stand up an identical environment from the Setup Playbook and the Terraform configuration with only the initial seed and zero tribal knowledge.

### RULE 9 — Never commit a real config file

Never commit environment-specific or sensitive configuration files (`terraform.tfvars`, `backend.tf`, `.env`) to the repository. Only commit their `.example` or `.template` counterparts with descriptive comments and placeholders. All real values must remain untracked and local, or managed securely via GCP Secret Manager.
