resource "aws_s3_bucket" "elitebucketdev" {
  bucket = join("-", [local.network.Environment, "elitebucket"])
  acl    = "private"

  tags = local.common_tags
}

//policy
resource "aws_iam_policy" "replication" {
  name = join("-", [local.network.Environment, "bucketPolicy"])

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.elitebucketdev.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.elitebucketdev.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.elitebucketdev.arn}/*"
    }
  ]
}
POLICY
  tags   = local.common_tags
}

//s3 policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.elitebucketdev.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "Allow"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.elitebucketdev.arn,
          "${aws_s3_bucket.elitebucketdev.arn}/*",
        ]
      },
    ]
  })
}