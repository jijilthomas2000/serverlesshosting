terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      Project = "cloud-resume"
      Managed = "terraform"
    }
  }
}

# CloudFront cert must be in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
