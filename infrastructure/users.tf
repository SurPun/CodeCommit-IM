// IAM USERS
module "dev-1" {
  source = "./modules/iam_user"

  name          = var.dev-1
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "attachment-1" {
  user       = module.dev-1.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_group_membership" "membership-1" {
  user   = module.dev-1.name
  groups = [aws_iam_group.developers.name]
}

// User Access Key
resource "aws_iam_access_key" "dev-1-key" {
  user = module.dev-1.name
}

output "dev_1_id" {
  value     = aws_iam_access_key.dev-1-key.id
  sensitive = true
}

output "dev_1_key" {
  value     = aws_iam_access_key.dev-1-key.secret
  sensitive = true
}
