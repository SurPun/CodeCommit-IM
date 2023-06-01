// IAM User
resource "aws_iam_user" "user" {
  name          = var.name
  path          = "/"
  force_destroy = true

  tags = {
    tag-key = "developers"
  }
}

// Attatch to IAM User
resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}
