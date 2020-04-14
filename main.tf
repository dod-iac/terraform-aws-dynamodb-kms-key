/**
 * ## Usage
 *
 * Creates a KMS Key for use with DynamoDB.
 *
 * ```hcl
 * module "dynamodb_kms_key" {
 *   source = "dod-iac/dynamodb-kms-key/aws"
 *
 *   name = format("alias/app-%s-dynamodb-%s", var.application, var.environment)
 *   description = format("A KMS key used to encrypt data at rest in DynamoDB for %s:%s.", var.application, var.environment)
 *   principals_encrypt = [var.submit_lambda_execution_role_arn]
 *   principals_decrypt = [var.export_lambda_execution_role_arn, aws_iam_role.user.arn]
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 is not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# https://docs.aws.amazon.com/kms/latest/developerguide/services-dynamodb.html#dynamodb-customer-cmk-policy

data "aws_iam_policy_document" "dynamodb" {
  policy_id = "key-policy-dynaomdb"
  statement {
    sid = "Enable IAM User Permissions"
    actions = [
      "kms:*",
    ]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        format(
          "arn:%s:iam::%s:root",
          data.aws_partition.current.partition,
          data.aws_caller_identity.current.account_id
        )
      ]
    }
    resources = ["*"]
  }
  statement {
    sid = "Allow DynamoDB to get information about the CMK"
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "dynamodb.amazonaws.com"
      ]
    }
    resources = ["*"]
  }
  dynamic "statement" {
    for_each = length(var.principals_encrypt) > 0 ? [1] : []
    content {
      sid = "Allow principals to encrypt."
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.principals_encrypt
      }
      resources = ["*"]
      condition {
        test     = "StringLike"
        variable = "kms:ViaService"
        values   = ["dynamodb.*.amazonaws.com"]
      }
    }
  }
  dynamic "statement" {
    for_each = length(var.principals_decrypt) > 0 ? [1] : []
    content {
      sid = "Allow principals to decrypt."
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey"
      ]
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.principals_decrypt
      }
      resources = ["*"]
      condition {
        test     = "StringLike"
        variable = "kms:ViaService"
        values   = ["dynamodb.*.amazonaws.com"]
      }
    }
  }
}

resource "aws_kms_key" "dynamodb" {
  description             = var.description
  deletion_window_in_days = var.key_deletion_window_in_days
  enable_key_rotation     = "true"
  policy                  = data.aws_iam_policy_document.dynamodb.json
  tags                    = var.tags
}

resource "aws_kms_alias" "dynamodb" {
  name          = var.name
  target_key_id = aws_kms_key.dynamodb.key_id
}
