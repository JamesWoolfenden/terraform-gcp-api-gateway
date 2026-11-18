output "api_id" {
  value       = google_api_gateway_api.main.id
  description = "ID of the API"
}

output "managed_service" {
  value       = google_api_gateway_api.main.managed_service
  description = "Managed service name of the API; restrict API keys to this service"
}

output "api_config_id" {
  value       = google_api_gateway_api_config.main.id
  description = "ID of the current API config"
}

output "gateway_id" {
  value       = google_api_gateway_gateway.main.id
  description = "ID of the gateway"
}

output "default_hostname" {
  value       = google_api_gateway_gateway.main.default_hostname
  description = "Default hostname the gateway serves the API on"
}
