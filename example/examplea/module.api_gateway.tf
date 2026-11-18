# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "api_gateway" {
  source                  = "../../"
  name                    = "example-api"
  display_name            = "Example API"
  region                  = "europe-west2"
  openapi_spec_path       = "${path.module}/openapi.yaml"
  backend_service_account = google_service_account.gateway.id
  consumers               = ["serviceAccount:${google_service_account.client.email}"]

  labels = {
    app = "example"
  }
}
