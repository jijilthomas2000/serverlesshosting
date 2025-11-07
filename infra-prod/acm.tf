# find the hosted zone in Route53 for your root domain
data "aws_route53_zone" "root" {
  name         = "jijilthomas.online"   # <-- IMPORTANT FIX THIS
  private_zone = false
}

# build domain list: (dev.jijilthomas.online and optionally www.dev*)
locals {
  cert_domains = var.enable_www ? [var.site_domain, "www.${var.site_domain}"] : [var.site_domain]
}

# request ACM certificate (MUST be in us-east-1 for CloudFront)
resource "aws_acm_certificate" "cf" {
  provider                  = aws.us_east_1
  domain_name               = local.cert_domains[0]
  subject_alternative_names = slice(local.cert_domains, 1, length(local.cert_domains))
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# create DNS validation records automatically
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cf.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.root.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# wait until validated
resource "aws_acm_certificate_validation" "cf" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cf.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

output "acm_certificate_arn" {
  value = aws_acm_certificate_validation.cf.certificate_arn
}
