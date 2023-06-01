// Deny Policy For Branch Protection
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
resource "aws_iam_group" "developers" {
  name = "Developers"
}

// Attach Deny Policy to IAM Group
resource "aws_iam_group_policy_attachment" "restrict" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.branch_policy.arn
}
