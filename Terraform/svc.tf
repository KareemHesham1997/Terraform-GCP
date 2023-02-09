resource "google_service_account" "node-service-account" {
  account_id = "node-service-account"
  project = "kareem-project-375811"
}


resource "google_project_iam_binding" "node-service-account-iam" {
  project = "kareem-project-375811"
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.node-service-account.email}"
  ]
}
