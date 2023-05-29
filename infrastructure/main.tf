terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "eu-west-2"
}

// CODECOMMIT MODULE
module "codecommit_repo" {
  source          = "./modules/code_commit"
  repository_name = var.repo_name
  description     = var.repo_description
  default_branch  = var.branch_name
}

// NULL Resource to prevent empty repository
resource "null_resource" "codecommit_interaction" {
  triggers = {
    # Trigger the null resource on every run
    run_on_creation = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
    aws codecommit create-commit --repository-name ${module.codecommit_repo.repository_name} --branch-name ${module.codecommit_repo.default_branch} --put-files "filePath=Readme.md,fileContent=V2VsY29tZSB0byBvdXIgdGVhbSByZXBvc2l0b3J5IQo="
    EOT
  }
}

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
