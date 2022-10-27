data "aws_acm_certificate" "acm_certificate" {
  domain = var.aws_acm_certificate.domain
}

data "aws_route53_zone" "route53_zone" {
  name = var.aws_route53_zone.name
}

data "aws_caller_identity" "caller_identify" {}

data "aws_iam_policy_document" "iam_policy_document_ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam_policy_document" {
  version = "2012-10-17"

  statement {
    sid = "EcsTaskPolicy"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [
      "*" # you could limit this to only the ECR repo you want
    ]
  }

  statement {
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }

  statement {
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "admin_role" {
  name               = var.iam_role
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document_ecs.json

  inline_policy {
    name = "EcsTaskExecutionRole"
    policy = data.aws_iam_policy_document.iam_policy_document.json
  }
}