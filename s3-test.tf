resource "aws_s3_bucket" "regionbuc" {
  bucket = join("-", [local.network.Environment, "eliteregionbuc"])
  acl    = "private"
  provider = aws.connection

  tags = local.common_tags
}
