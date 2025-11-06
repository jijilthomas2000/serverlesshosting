
# A record for apex dev.jijilthomas.online -> CloudFront
resource "aws_route53_record" "dev_apex" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = var.site_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA (IPv6) alias
resource "aws_route53_record" "dev_apex_ipv6" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = var.site_domain
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}
