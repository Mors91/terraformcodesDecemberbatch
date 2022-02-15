resource "aws_acm_certificate" "cert" {
  domain_name       = "*.elitelabtools.com"
  validation_method = "DNS"

  tags = merge(local.common_tags, { Name = "windowsServer-certificate", Company = "EliteSolutionsIT", franchise = "morscorp" })

  lifecycle {
    create_before_destroy = true
  }
}

////Create record
resource "aws_route53_record" "test_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.elitelabtools.zone_id
}

resource "aws_acm_certificate_validation" "cert_validate" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.test_record : record.fqdn]
}

///records
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.elitelabtools.zone_id
  name    = "nginxserver.elitelabtools.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
