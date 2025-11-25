locals {
  table_locations       = [for key in var.billing_tables : { table = key, location = data.google_bigquery_dataset.table_datasets[key].location }]
  wif_audience          = "//iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.stacklet_access.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.stacklet_account.workload_identity_pool_provider_id}"
  wif_impersonation_url = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${google_service_account.billing_access.email}:generateAccessToken"
}

output "project_id" {
  value       = local.project_id
  description = "The project the created resources exist in."
}

output "table_locations" {
  value       = local.table_locations
  description = "The data location for every table made accessible."
}

output "wif_audience" {
  value       = local.wif_audience
  description = "The audience value required for impersonation interactions."
}

output "wif_impersonation_url" {
  value       = local.wif_impersonation_url
  description = "The URL used for impersonation interactions."
}

output "access_blob" {
  value = base64encode(jsonencode({
    projectId           = local.project_id,
    tableLocations      = local.table_locations,
    wifAudience         = local.wif_audience,
    wifImpersonationURL = local.wif_impersonation_url,
    roundtripDigest     = var.roundtrip_digest,
  }))
  description = "All other outputs crammed into a single copy/pasteable value."
}