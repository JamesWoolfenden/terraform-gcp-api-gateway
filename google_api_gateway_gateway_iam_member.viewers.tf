resource "google_api_gateway_gateway_iam_member" "viewers" {
  provider = google-beta
  for_each = toset(var.viewers)
  gateway  = google_api_gateway_gateway.main.gateway_id
  region   = var.region
  role     = "roles/apigateway.viewer"
  member   = each.value
}
