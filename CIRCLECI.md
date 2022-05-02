# CircleCI Terraform Instructions

## Setting up the service account

1. Export project ID: `export TERRAFORM_PROJECT_IDENTIFIER=$(gcloud config get-value project)`
2. Create a service account: `gcloud iam service-accounts create terraform --display-name "Terraform admin account"`
3. Export service account email: `export TERRAFORM_SERVICE_ACCOUNT_EMAIL="terraform@$TERRAFORM_PROJECT_IDENTIFIER.iam.gserviceaccount.com"`
4. Create JSON key for service account: `gcloud iam service-accounts keys create --iam-account $TERRAFORM_SERVICE_ACCOUNT_EMAIL ~/gcloud-terraform-admin.json`
5. Add viewer role to service account: `gcloud projects add-iam-policy-binding $TERRAFORM_PROJECT_IDENTIFIER --member serviceAccount:$TERRAFORM_SERVICE_ACCOUNT_EMAIL --role roles/viewer`
6. Add storage admin role to service account: `gcloud projects add-iam-policy-binding $TERRAFORM_PROJECT_IDENTIFIER --member serviceAccount:$TERRAFORM_SERVICE_ACCOUNT_EMAIL --role roles/storage.admin`
7. Add full project owner for service account: `gcloud projects add-iam-policy-binding $TERRAFORM_PROJECT_IDENTIFIER --member serviceAccount:$TERRAFORM_SERVICE_ACCOUNT_EMAIL --role roles/owner`

## Setting up CircleCI

1. Get the creds from the previous JSON file: `cat ~/gcloud-terraform-admin.json`
2. Open project settings in CircleCI for the project, and go to Environment Variables.
3. Create a new variable called `GOOGLE_CREDENTIALS`. Pass the whole JSON output from step 1 to the value.
