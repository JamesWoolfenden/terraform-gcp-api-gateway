resource "google_api_gateway_api_iam_member" "viewers" {
  provider = google-beta
  for_each = toset(var.viewers)
  api      = google_api_gateway_api.main.api_id
  role     = "roles/apigateway.viewer"
  member   = each.value
}
