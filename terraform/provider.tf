terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.19.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-kube-project-344514"
    prefix = "gke"
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}