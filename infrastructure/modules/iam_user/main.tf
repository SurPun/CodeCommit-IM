// IAM User
resource "aws_iam_user" "user" {
  name          = var.name
  path          = "/"
  force_destroy = true

  tags = {
    tag-key = "developers"
  }
}