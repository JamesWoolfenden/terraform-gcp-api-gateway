resource "google_api_gateway_api_config" "main" {
  provider             = google-beta
  api                  = google_api_gateway_api.main.api_id
  api_config_id_prefix = "${var.name}-"
  display_name         = var.display_name
  labels               = var.labels

  openapi_documents {
    document {
      path     = basename(var.openapi_spec_path)
      contents = filebase64(var.openapi_spec_path)
    }
  }

  # The gateway calls the backend (Cloud Run, Cloud Functions, ...) with a
  # Google-signed ID token for this dedicated SA, so the backend can stay
  # private (no allUsers invoker).
  gateway_config {
    backend_config {
      google_service_account = local.backend_service_account_email
    }
  }

  # API configs are immutable; a new one is created before the gateway is
  # switched over and the old one removed.
  lifecycle {
    create_before_destroy = true
  }
}
