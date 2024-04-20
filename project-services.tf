resource "google_project_service" "gke-test" {
  for_each           = toset(var.services)
  service            = "${each.key}.googleapis.com"
  disable_on_destroy = false
}