# modules/vertex_ai — Vertex AI integration (feature-gated)

resource "google_project_service" "vertex" {
  count              = var.enable ? 1 : 0
  project            = var.project_id
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

# Example lightweight Vertex AI resource to verify provisioning
resource "google_vertex_ai_dataset" "dataset" {
  count               = var.enable ? 1 : 0
  project             = var.project_id
  region              = var.region
  display_name        = "${var.project_prefix}-dataset-${var.environment}"
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/text_1.0.0.yaml"

  depends_on = [google_project_service.vertex]
}
