// IAM User
resource "aws_iam_user" "user-1" {
  name = var.user_name
  path = "/system/"

  tags = {
    tag-key = "developers"
  }
}
