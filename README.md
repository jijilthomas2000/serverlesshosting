# serverlesshosting

# Serverless Website Hosting on AWS (Terraform + CloudFront + ACM + S3)

This project demonstrates how to deploy a **fully serverless static website** using AWS services and Infrastructure as Code (Terraform). The setup ensures scalability, performance, global CDN distribution, and HTTPS security using Amazon CloudFront and ACM.

---

## 🚀 Project Overview

This architecture hosts a static front-end application (HTML/CSS/JS or SPA framework like React/Vue) using:

* **Amazon S3** – Static website hosting
* **Amazon CloudFront** – Global CDN distribution
* **AWS ACM** – Free SSL certificate for HTTPS
* **Route53** – Domain DNS management
* **Terraform** – To build and manage the entire infrastructure
* **GitHub Actions** – CI/CD pipeline to deploy code to S3 automatically

The result is a high‑performance, low‑cost, globally accessible serverless website.

---

## 🏗️ Architecture Diagram

```
User → CloudFront → S3 Bucket (Static Frontend)
                ↓
        API Gateway (REST API)
                ↓
            Lambda Function
                ↓
            DynamoDB Table
                ↓
        Terraform-managed Infrastructure
                ↓
            ACM Certificate
                ↓
            Route53 DNS
```

User → CloudFront → S3 Bucket → Terraform-managed Infrastructure
↓
ACM Certificate
↓
Route53 DNS

```

---

## 📂 Repository Structure

```

.
backend/                  # Lambda function source code
└── visitor.py
frontend/                 # Same frontend used for both dev & prod
  index.html
  style.css
infra/                    # Dev environment terraform
 ├── acm.tf
 ├── apigw.tf
 ├── backend.tf
 ├── cloudfront.tf
 ├── dynamodb.tf
 ├── lambda.tf
 ├── route53.tf
 ├── s3.tf
 ├── variables.tf
 ├── dev.tfvars
 └── output.tf
 infra-prod/               # Prod environment terraform
 ├── (same structure as infra)
 .github/workflows/        # GitHub Actions CI/CD
 ├── deploy-dev.yml
  └── deploy-prod.yml
─ README.md

```

---

## 🛠️ AWS Resources Created

### 1️⃣ **S3 Bucket**
- Stores the static website
- Versioning enabled (optional)
- Public access blocked
- CloudFront origin access is used

### 2️⃣ **ACM Certificate**
- Created in **us-east-1** (mandatory for CloudFront)
- Domain validation via Route53 CNAME record

### 3️⃣ **CloudFront Distribution**
- S3 bucket as origin
- HTTPS enforced
- Caching enabled
- Custom domain configured

### 4️⃣ **Route53 DNS Records**
- Creates an **A record (Alias)** that points your domain → CloudFront

---

## ⚙️ Terraform Deployment Steps

### 1. Initialize Terraform
```

terraform init

```

### 2. Validate the files
```

terraform validate

```

### 3. View the plan
```

terraform plan

```

### 4. Apply changes
```

terraform apply -auto-approve

````

---

## 🔐 GitHub Actions CI/CD Pipeline
The workflow automatically deploys your website to the S3 bucket whenever you push code to the `dev` or `main` branches.

### Example workflow:
```yaml
ame: Deploy Frontend to S3

on:
  push:
    branches: ["dev"]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-south-1

      - name: Sync S3
        run: aws s3 sync ./frontend s3://your-bucket-name --delete
````

---

## 🔍 Common Issues & Fixes

### **Issue: ACM Certificate not issued**

✔ Make sure certificate is created in **us-east-1**
✔ Route53 validation CNAME must propagate

### **Issue: CloudFront shows 403**

✔ Check origin access policy for S3 bucket
✔ Ensure index.html exists

### **Issue: Deployment fails in GitHub Actions**

✔ Update AWS keys in repo secrets
✔ Ensure correct bucket name in `aws s3 sync`

---

## 📈 Benefits of This Architecture

* 100% Serverless
* No EC2 or servers to manage
* High performance via CloudFront CDN
* Free SSL using ACM
* Automated deployments via GitHub Actions
* Scalable, secure & cost‑effective

---

## 🧾 Final Notes

This setup is perfect for:

* Portfolio websites
* Landing pages
* Single Page Applications
* Documentation sites

You can extend this with:

* Lambda@Edge for redirects
* API Gateway + Lambda for backend
* CloudWatch for metrics

---

If you found this helpful, don't forget to ⭐ star the repository!

---

## 🔄 CI/CD for Dev & Prod Environments

This project uses **two separate GitHub Actions workflows** to deploy the same frontend code into different S3 buckets and CloudFront distributions.

### **Development Workflow – `deploy-dev.yml`**

* Triggers on pushes to the `dev` branch
* Deploys to: `dev.example.com`
* Syncs frontend → `dev S3 bucket`
* Invalidates **dev CloudFront distribution**
* Uses credentials stored in GitHub Secrets

### **Production Workflow – `deploy-prod.yml`**

* Triggers on pushes to the `main` branch
* Deploys to: `example.com`
* Syncs frontend → `prod S3 bucket`
* Invalidates **production CloudFront distribution**

---

## 🧮 Visitor Counter Architecture (API Gateway + Lambda + DynamoDB)

A serverless backend is used to track website visitor counts.

### **Flow Diagram**

```
User Browser → API Gateway → Lambda Function → DynamoDB Table
```

### **Components**

#### **1️⃣ API Gateway**

* Exposes a public HTTPS endpoint
* Integrates directly with Lambda

#### **2️⃣ Lambda (visitor.py)**

* Written in Python
* Retrieves current visitor count from DynamoDB
* Increments count
* Stores updated value back into DynamoDB
* Returns count as JSON

Example response:

```json
{
  "visits": 1456
}
```

#### **3️⃣ DynamoDB Table**

* Partition key: `id` = "visitor_count"
* Attribute: `count` (Number)
* Very low cost (almost free in free-tier)

---

## 🌐 Environment Separation (Dev vs Prod)

### **Directory Structure**

```
infra/        → Development environment resources
infra-prod/   → Production environment resources
```

Each folder contains:

* Its own backend configuration
* Its own S3 bucket
* Its own CloudFront distribution
* Its own ACM certificate
* Its own API Gateway + Lambda + DynamoDB

This ensures:

* Safe testing before production
* No risk of breaking the live website

---

