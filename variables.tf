variable "name" {
  type        = string
  description = "ID used for the API, the API config prefix and the gateway"

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,47}[a-z0-9])?$", var.name))
    error_message = "var.name must be lowercase letters, digits or hyphens, start with a letter and be at most 49 characters"
  }
}

variable "display_name" {
  type        = string
  description = "Human-readable name for the API, config and gateway"

  validation {
    condition     = length(trimspace(var.display_name)) > 0
    error_message = "var.display_name must be a non-empty string"
  }
}

variable "region" {
  type        = string
  description = "Region the gateway is deployed in"
  default     = "europe-west2"

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "var.region must be a non-empty string"
  }
}

variable "openapi_spec_path" {
  type        = string
  description = "Path to the OpenAPI (2.0) document describing the API, its x-google-backend and its security definitions"

  validation {
    condition     = fileexists(var.openapi_spec_path) && can(regex("\\.(ya?ml|json)$", var.openapi_spec_path))
    error_message = "var.openapi_spec_path must point to an existing .yaml, .yml or .json file"
  }
}

variable "backend_service_account" {
  type        = string
  description = "ID (projects/PROJECT/serviceAccounts/EMAIL) of the dedicated service account the gateway uses to call the backend; grant it the invoker role on the backend"

  validation {
    condition     = can(regex("^projects/[^/]+/serviceAccounts/[^/@]+@[^/]+$", var.backend_service_account))
    error_message = "var.backend_service_account must be a service account id of the form projects/PROJECT/serviceAccounts/EMAIL"
  }

  validation {
    condition     = !can(regex("(-compute@developer|@appspot)\\.gserviceaccount\\.com$", var.backend_service_account))
    error_message = "var.backend_service_account must not be a default GCP service account (Compute Engine or App Engine)"
  }
}

variable "enable_managed_service" {
  type        = bool
  description = "Enable the API's managed service in the project (required for API keys and consumers)"
  default     = true

  validation {
    condition     = var.enable_managed_service != null
    error_message = "var.enable_managed_service must not be null"
  }
}

variable "consumers" {
  type        = list(string)
  description = "IAM members granted roles/servicemanagement.serviceConsumer on the API's managed service"
  default     = []

  validation {
    condition     = alltrue([for m in var.consumers : !contains(["allUsers", "allAuthenticatedUsers"], m)])
    error_message = "var.consumers must not contain allUsers or allAuthenticatedUsers"
  }

  validation {
    condition     = alltrue([for m in var.consumers : can(regex("^(user|serviceAccount|group|domain|principal|principalSet):.+", m))])
    error_message = "var.consumers entries must be IAM member strings such as group:EMAIL"
  }
}

variable "consumer_project" {
  type        = string
  description = "Project the consumer grants are made in. Null uses the current project"
  default     = null

  validation {
    condition     = var.consumer_project == null || can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.consumer_project))
    error_message = "var.consumer_project must be null or a valid project ID"
  }
}

variable "viewers" {
  type        = list(string)
  description = "IAM members granted roles/apigateway.viewer on the API and the gateway"
  default     = []

  validation {
    condition     = alltrue([for m in var.viewers : !contains(["allUsers", "allAuthenticatedUsers"], m)])
    error_message = "var.viewers must not contain allUsers or allAuthenticatedUsers"
  }

  validation {
    condition     = alltrue([for m in var.viewers : can(regex("^(user|serviceAccount|group|domain|principal|principalSet):.+", m))])
    error_message = "var.viewers entries must be IAM member strings such as group:EMAIL"
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the API, config and gateway"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", k)) && can(regex("^[a-z0-9_-]{0,63}$", v))])
    error_message = "var.labels keys must start with a lowercase letter and keys/values must be lowercase alphanumerics, underscores, or hyphens, up to 63 characters (GCP label constraints)"
  }
}
