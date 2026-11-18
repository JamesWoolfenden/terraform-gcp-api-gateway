# terraform-gcp-api-gateway

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-api-gateway/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-gcp-api-gateway/actions)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-api-gateway.svg)](https://github.com/JamesWoolfenden/terraform-gcp-api-gateway/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-api-gateway.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-api-gateway/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for API Gateway. Creates the API, an API config built from an OpenAPI document file, and a gateway serving it. The gateway calls the backend as a dedicated service account (`gateway_config.backend_config.google_service_account`), so the backend can stay private. The API's managed service is enabled, consumers get `roles/servicemanagement.serviceConsumer` on it, and viewers get `roles/apigateway.viewer` on the API and gateway; public members are rejected. The API Gateway resources only exist in the `google-beta` provider (7.31.0), so callers must configure `google-beta`. API Gateway has no CMEK option.

## Usage

Add **module.api_gateway.tf** to your code:-

```terraform
module "api_gateway" {
  source                  = "jameswoolfenden/api-gateway/gcp"
  name                    = "example-api"
  display_name            = "Example API"
  region                  = "europe-west2"
  openapi_spec_path       = "${path.module}/openapi.yaml"
  backend_service_account = google_service_account.gateway.id
  consumers               = ["serviceAccount:${google_service_account.client.email}"]
}
```

Grant the backend SA `roles/run.invoker` on the Cloud Run backend. See [example/examplea](example/examplea) for a complete working example, including an [openapi.yaml](example/examplea/openapi.yaml) secured with an API key (do not offer a bare Google ID token scheme as an alternative: any service account can mint one for any audience).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google-beta_google_api_gateway_api.main](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api) | resource |
| [google-beta_google_api_gateway_api_config.main](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api_config) | resource |
| [google-beta_google_api_gateway_api_iam_member.viewers](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api_iam_member) | resource |
| [google-beta_google_api_gateway_gateway.main](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_gateway) | resource |
| [google-beta_google_api_gateway_gateway_iam_member.viewers](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_gateway_iam_member) | resource |
| [google_endpoints_service_consumers_iam_member.consumers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/endpoints_service_consumers_iam_member) | resource |
| [google_project_service.managed_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backend_service_account"></a> [backend\_service\_account](#input\_backend\_service\_account) | ID (projects/PROJECT/serviceAccounts/EMAIL) of the dedicated service account the gateway uses to call the backend; grant it the invoker role on the backend | `string` | n/a | yes |
| <a name="input_consumer_project"></a> [consumer\_project](#input\_consumer\_project) | Project the consumer grants are made in. Null uses the current project | `string` | `null` | no |
| <a name="input_consumers"></a> [consumers](#input\_consumers) | IAM members granted roles/servicemanagement.serviceConsumer on the API's managed service | `list(string)` | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Human-readable name for the API, config and gateway | `string` | n/a | yes |
| <a name="input_enable_managed_service"></a> [enable\_managed\_service](#input\_enable\_managed\_service) | Enable the API's managed service in the project (required for API keys and consumers) | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels applied to the API, config and gateway | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | ID used for the API, the API config prefix and the gateway | `string` | n/a | yes |
| <a name="input_openapi_spec_path"></a> [openapi\_spec\_path](#input\_openapi\_spec\_path) | Path to the OpenAPI (2.0) document describing the API, its x-google-backend and its security definitions | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region the gateway is deployed in | `string` | `"europe-west2"` | no |
| <a name="input_viewers"></a> [viewers](#input\_viewers) | IAM members granted roles/apigateway.viewer on the API and the gateway | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_config_id"></a> [api\_config\_id](#output\_api\_config\_id) | ID of the current API config |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | ID of the API |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | Default hostname the gateway serves the API on |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | ID of the gateway |
| <a name="output_managed_service"></a> [managed\_service](#output\_managed\_service) | Managed service name of the API; restrict API keys to this service |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "apigateway.apiconfigs.create",
    "apigateway.apiconfigs.delete",
    "apigateway.apiconfigs.get",
    "apigateway.apiconfigs.update",
    "apigateway.apis.create",
    "apigateway.apis.delete",
    "apigateway.apis.get",
    "apigateway.apis.getIamPolicy",
    "apigateway.apis.setIamPolicy",
    "apigateway.apis.update",
    "apigateway.gateways.create",
    "apigateway.gateways.delete",
    "apigateway.gateways.get",
    "apigateway.gateways.getIamPolicy",
    "apigateway.gateways.setIamPolicy",
    "apigateway.gateways.update",
    "apigateway.operations.get",
    "resourcemanager.projects.get",
    "servicemanagement.services.getIamPolicy",
    "servicemanagement.services.setIamPolicy",
    "serviceusage.services.disable",
    "serviceusage.services.enable",
    "serviceusage.services.get",
    "serviceusage.services.list"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "apigateway.apiconfigs.get",
    "apigateway.apis.get",
    "apigateway.apis.getIamPolicy",
    "apigateway.gateways.get",
    "apigateway.gateways.getIamPolicy",
    "apigateway.operations.get",
    "resourcemanager.projects.get",
    "servicemanagement.services.getIamPolicy",
    "serviceusage.services.get",
    "serviceusage.services.list"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/jameswoolfenden/terraform-gcp-api-gateway/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/jameswoolfenden/terraform-gcp-api-gateway/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
