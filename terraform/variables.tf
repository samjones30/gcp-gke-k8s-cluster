variable "project_id" {}

variable "project_name" {
  default = "gke-learning"
}

variable "region" {
  default = "us-central1"
}

variable "k8s_nodes" {
  description = "Map of K8s node configuration"
  type        = map(any)
}