data "aws_route53_zone" "elitelabtools" {
  name         = "elitelabtools.com"
  private_zone = false
}