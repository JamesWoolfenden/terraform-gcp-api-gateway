resource "google_api_gateway_api" "main" {
  provider     = google-beta
  api_id       = var.name
  display_name = var.display_name
  labels       = var.labels
}
