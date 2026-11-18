resource "google_service_account" "gateway" {
  account_id   = "api-gateway-backend"
  display_name = "Dedicated SA API Gateway uses to call the Cloud Run backend"
}

resource "google_service_account" "client" {
  account_id   = "api-gateway-client"
  display_name = "Example consumer of the API"
}
