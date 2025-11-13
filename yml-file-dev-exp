🟩 DEV CI/CD Explanation (deploy-dev.yml)
🔔 1. Trigger condition
on:
  push:
    branches: ["dev"]


➡ When you push to the dev branch, this pipeline runs.
This means only DEV environment gets updated.

🧩 2. Checkout repository
uses: actions/checkout@v4


➡ Downloads your GitHub repo files into the CI machine.

🔐 3. Configure AWS credentials
uses: aws-actions/configure-aws-credentials@v3


➡ Authenticates GitHub Actions to AWS using secrets stored in the repo.

Without this step, it cannot upload to S3, invalidate CloudFront, or run Terraform.

🔄 4. Replace API URL inside index.html
sed -i 's|{{API_URL}}|https://hvoayuv4gg.execute-api.ap-south-1.amazonaws.com/dev/|g' frontend/index.html


➡ The frontend contains a placeholder {{API_URL}}.
➡ This command replaces it with the DEV API Gateway URL.

So that the web page calls the correct backend when deployed.

✔ Required because DEV and PROD use different API Gateway endpoints.

🪣 5. Sync frontend to Dev S3 bucket
aws s3 sync ./frontend s3://dev.jijilthomas.online --delete


➡ Uploads all frontend files into the DEV S3 bucket.
➡ --delete removes old files.

This instantly updates the DEV website.

🔨 6. Setup Terraform
uses: hashicorp/setup-terraform@v3


➡ Installs Terraform so we can run Terraform commands.

🏗 7. Terraform init
working-directory: infra
run: terraform init


➡ Initializes Terraform in the dev infra directory.

⚠️ You do NOT apply infra in DEV pipeline — you only use Terraform to read output values.

🆔 8. Get CloudFront Distribution ID
terraform output -raw cloudfront_distribution_id


➡ Reads your CloudFront ID (which Terraform previously deployed manually).
➡ Saves ID to GitHub environment variable $CF_ID.

🚀 9. Create CloudFront invalidation
aws cloudfront create-invalidation --distribution-id $CF_ID --paths "/*"


➡ Tells CloudFront to refresh cached files.
➡ Ensures your newest frontend appears instantly (no delay).

🟦 Summary of DEV Pipeline
Step	Purpose
Sync frontend to S3	Deploys website
Replace API URL	Ensure correct backend
CloudFront invalidate	Refresh cache
Terraform used only to read outputs	No infra changes

DEV pipeline is lightweight → Only deploy frontend + invalidate cache.
