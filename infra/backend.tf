terraform {
  backend "s3" {
    bucket         = "tfstate-jijilthomas-ap-south-1"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}
