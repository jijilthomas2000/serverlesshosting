variable "site_domain" {
  description = "Apex/root domain"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket to store website content (no dots recommended)"
  type        = string
}

variable "enable_www" {
  description = "Also serve www subdomain"
  type        = bool
}

variable "environment" {
  description = "environment name (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region to deploy"
  type        = string
}
