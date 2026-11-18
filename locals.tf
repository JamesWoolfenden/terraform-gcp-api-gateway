locals {
  # var.backend_service_account is a google_service_account id
  # ("projects/P/serviceAccounts/EMAIL"); backend_config needs the email.
  backend_service_account_email = element(split("/", var.backend_service_account), 3)

  consumer_project = coalesce(var.consumer_project, data.google_project.current.project_id)
}
