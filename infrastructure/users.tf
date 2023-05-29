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
