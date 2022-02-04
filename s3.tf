resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My . bucket"
    Environment = "Dev"
    managedwith = "terraform"
  }
}