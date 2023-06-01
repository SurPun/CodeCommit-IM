// --------------------- IAM User 1 --------------------- //

module "dev_1" {
  source = "./modules/iam_user"

  name          = var.dev_1
  path          = "/"
  force_destroy = true
}

// Add User to Group
resource "aws_iam_user_group_membership" "member_1" {
  user   = module.dev_1.name
  groups = [aws_iam_group.developers.name]
}

// User Access Key
resource "aws_iam_access_key" "dev_1_cred" {
  user = module.dev_1.name
}

output "dev_1_id" {
  value     = aws_iam_access_key.dev_1_cred.id
  sensitive = true
}

output "dev_1_key" {
  value     = aws_iam_access_key.dev_1_cred.secret
  sensitive = true
}

// --------------------- IAM User 2 --------------------- //

module "dev_2" {
  source = "./modules/iam_user"

  name          = var.dev_2
  path          = "/"
  force_destroy = true
}

// Add User to Group
resource "aws_iam_user_group_membership" "member_2" {
  user   = module.dev_2.name
  groups = [aws_iam_group.developers.name]
}

// User Access Key
resource "aws_iam_access_key" "dev_2_cred" {
  user = module.dev_2.name
}

output "dev_2_id" {
  value     = aws_iam_access_key.dev_2_cred.id
  sensitive = true
}

output "dev_2_key" {
  value     = aws_iam_access_key.dev_2_cred.secret
  sensitive = true
}

/* TIPS

----------------------------- Terraform Output
terraform output dev_1_id
terraform output dev_1_key


----------------------------- Git Config Helper
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

----------------------------- Git Clone
git clone https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/YOUR_VALUES

*/
