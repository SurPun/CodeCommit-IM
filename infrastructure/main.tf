provider "aws" {
  region = "eu-west-2"
}

// CODECOMMIT MODULE
module "codecommit_repo" {
  source = "./modules/code_commit"

  repository_name = var.repo_name
  description     = var.repo_description
  default_branch  = var.branch_name
}

// NULL Resource to prevent empty repository
resource "null_resource" "codecommit_interaction" {
  depends_on = [module.codecommit_repo]

  triggers = {
    run_on_creation = timestamp()
  }

  // Base64 encoded value...
  provisioner "local-exec" {
    command = <<EOT
    aws codecommit create-commit --repository-name ${module.codecommit_repo.repository_name} --branch-name ${module.codecommit_repo.default_branch} --put-files "filePath=README.md,fileContent=QnJhbmNoIFByb3RlY3RlZCBSZXBvc2l0b3J5"
    EOT
  }

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
