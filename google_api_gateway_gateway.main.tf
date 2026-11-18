resource "google_api_gateway_gateway" "main" {
  provider     = google-beta
  gateway_id   = var.name
  region       = var.region
  api_config   = google_api_gateway_api_config.main.id
  display_name = var.display_name
  labels       = var.labels
}
