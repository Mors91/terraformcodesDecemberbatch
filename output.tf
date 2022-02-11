output "password" {
  description = "Password gpg key output of IAM User"
  value      = aws_iam_user_login_profile.sugarray_login.encrypted_password
  
}
output "user" {
  description = "sugarray"
  value      = aws_iam_user.sugarray.name
}