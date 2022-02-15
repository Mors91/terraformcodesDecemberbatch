terraform {
  backend "s3" {
    bucket  = "terraform-state-xyzc"
    key     = "elitebucketstate"
    region  = "us-east-1"
    profile = "customprofile"
  }
}

resource "aws_s3_bucket" "remote" {
  bucket = "terraform-state-xyzc"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = local.common_tags
}