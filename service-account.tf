resource "google_service_account" "gke-test" {
  account_id = var.service_account.name
}

resource "google_project_iam_member" "gke-test" {
  project = var.project_id
  count   = length(var.service_account.roles)
  role    = "roles/${var.service_account.roles[count.index]}"
  member  = "serviceAccount:${google_service_account.gke-test.email}"
}
