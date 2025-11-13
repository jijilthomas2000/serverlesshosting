🔴 PROD CI/CD Explanation (deploy-prod.yml)

The PROD pipeline is heavier because it updates BOTH:
✔ Infrastructure
✔ Frontend

🔔 1. Trigger on prod branch
on:
  push:
    branches: ["prod"]


➡ Only runs when you push to prod.

🔐 2. Configure AWS credentials

Same as DEV.

🔧 3. Install Terraform
uses: hashicorp/setup-terraform@v3

🏗 4. Terraform init (prod infra)
working-directory: infra-prod
run: terraform init -reconfigure


➡ Initializes Terraform for the prod environment.

🏗 5. Terraform apply (prod infra)
working-directory: infra-prod
run: terraform apply -auto-approve -var-file=prod.tfvars


➡ Automatically applies changes:

S3 bucket

API Gateway

Lambda

DynamoDB

CloudFront

ACM

DNS

⚡ Production infra is updated at every prod commit.

❗ This is the MAJOR difference from DEV.

🔄 6. Replace API URL (Prod)
sed -i 's|{{API_URL}}|https://pnw87xkd05.execute-api.ap-south-1.amazonaws.com/prod/|g' index.html


➡ Replaces placeholder with production API Gateway URL.

🪣 7. Upload frontend to PROD S3
aws s3 sync ./frontend s3://portfolio.jijilthomas.online --delete


➡ Uploads website to main domain.

🆔 8. Get CloudFront ID & Invalidate

Same as DEV, but for PROD.

🟦 Summary of PROD Pipeline
Step	Purpose
Terraform apply	Updates full infra
Sync frontend to S3	Deploys website
Replace API URL	Connects to PROD backend
CloudFront invalidate	Force refresh cache
🟩 Key Differences (Very Important)
Feature	DEV	PROD
Branch	dev	prod
Terraform applied?	❌ No (only init + read output)	✔ Yes (full infra deployed)
URL replaced	DEV API	PROD API
S3 bucket	dev.jijilthomas.online	portfolio.jijilthomas.online
Purpose	Testing environment	Live environment
