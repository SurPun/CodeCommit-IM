// IAM Policy For Branch Protection
resource "aws_iam_policy" "branch_policy" {
  name        = "DenyChangesToMain"
  path        = "/"
  description = "Branch Protection Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Deny",
        "Action" : [
          "codecommit:GitPush",
          "codecommit:DeleteBranch",
          "codecommit:PutFile",
          "codecommit:MergeBranchesByFastForward",
          "codecommit:MergeBranchesBySquash",
          "codecommit:MergeBranchesByThreeWay",
          "codecommit:MergePullRequestByFastForward",
          "codecommit:MergePullRequestBySquash",
          "codecommit:MergePullRequestByThreeWay"
        ],
        "Resource" : "${module.codecommit_repo.arn}",
        "Condition" : {
          "StringEqualsIfExists" : {
            "codecommit:References" : [
              "refs/heads/main",
            ]
          },
          "Null" : {
            "codecommit:References" : "false"
          }
        }
      }
    ]
  })
}

// IAM Group
resource "aws_iam_group" "restricted_devs" {
  name = "Restricted-Devs"
}

// Attach to IAM Group
resource "aws_iam_group_policy_attachment" "restrict" {
  group      = aws_iam_group.restricted_devs.name
  policy_arn = aws_iam_policy.branch_policy.arn
}

// IAM Role
resource "aws_iam_role" "codecommit_role" {
  name = "codecommit-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codecommit.amazonaws.com"
        }
      }
    ]
  })
}

// Attach to IAM Role
resource "aws_iam_role_policy_attachment" "codecommit_branch_policy_attachment" {
  role       = aws_iam_role.codecommit_role.name
  policy_arn = aws_iam_policy.branch_policy.arn
}
