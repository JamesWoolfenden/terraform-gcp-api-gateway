# Lets each consumer call the API (servicemanagement.services.use on the
# API's managed service), e.g. to create API keys restricted to it.
resource "google_endpoints_service_consumers_iam_member" "consumers" {
  for_each         = toset(var.consumers)
  service_name     = google_api_gateway_api.main.managed_service
  consumer_project = local.consumer_project
  role             = "roles/servicemanagement.serviceConsumer"
  member           = each.value
}
