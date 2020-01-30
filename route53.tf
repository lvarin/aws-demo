locals {
  domain_name = "${var.subdomain_name}.${var.zone_name}"
}

data "aws_route53_zone" "zone" {
    name         = "${var.zone_name}."
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "domain" {
  name    = local.domain_name
  type    = "CNAME"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = ["${aws_alb.demo_eu_alb.dns_name}"]
}
