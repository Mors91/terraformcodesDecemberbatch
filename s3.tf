# resource "aws_s3_bucket" "my-bucket" {
#   bucket = "elitebucketdev"
#   acl    = "private"

#   tags = {
#     Name        = "elitebucketdev"
#     Environment = "dev"
#     Managedwith = "terraform"
#   }
# }

# //policy
# resource "aws_iam_policy" "replication" {
#   name = "elite-bucket-policy"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:GetReplicationConfiguration",
#         "s3:ListBucket"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.my-bucket.arn}"
#       ]
#     },
#     {
#       "Action": [
#         "s3:GetObjectVersionForReplication",
#         "s3:GetObjectVersionAcl",
#          "s3:GetObjectVersionTagging"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.my-bucket.arn}/*"
#       ]
#     },
#     {
#       "Action": [
#         "s3:ReplicateObject",
#         "s3:ReplicateDelete",
#         "s3:ReplicateTags"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_s3_bucket.my-bucket.arn}/*"
#     }
#   ]
# }
# POLICY
#   tags = {
#     Name        = "elitebucketdevPolicy"
#     Environment = "dev"
#     Managedwith = "terraform"
#   }
# }