# The API's generated managed service must be enabled in the project before
# API keys / consumer access to it work.
resource "google_project_service" "managed_service" {
  count              = var.enable_managed_service ? 1 : 0
  service            = google_api_gateway_api.main.managed_service
  disable_on_destroy = false
}
