# Kubernetes Cluster on GCP - GKE

This example deploys a GKE managed Kubernetes cluster with a node pool of three nodes. It is all deployed via Terraform.

## Deployment

### Deploy the Infrastructure

1. Authenticate to GCloud - `gcloud auth application-default login`
2. Initialise the Terraform - `terraform init`
3. Apply the Terraform - `terraform apply`

### Connect to the Cluster

The first step is to retrieve the cluster credentials from GKE:

`gcloud container clusters get-credentials <cluster_name> --region <region_name>`

## Cluster Resources

### Cluster dashboard

1. Deploy the following for a k8s dashboard: `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml`
2. Deploy a service account and cluster role binding: `kubectl apply -f ./k8s-resources/kubernetes-dashboard-admin.yaml
3. Generate an auth token: `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')`
4. Use a kubectl proxy to navigate to the dashboard: `kubectl proxy`
5. Navigate to the dashboard and use token authN: `http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`
