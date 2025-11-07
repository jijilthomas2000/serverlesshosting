terraform {
  backend "s3" {
    bucket         = "tfstate-jijilthomas-ap-south-1"
    key            = "serverlesshosting/infra-prod.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}
