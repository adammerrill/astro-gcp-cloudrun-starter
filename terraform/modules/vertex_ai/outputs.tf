output "dataset_id" {
  value       = var.enable ? google_vertex_ai_dataset.dataset[0].id : null
  description = "The Vertex AI Dataset ID"
}
