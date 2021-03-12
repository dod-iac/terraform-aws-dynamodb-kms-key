<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates a KMS Key for use with DynamoDB.

```hcl
module "dynamodb_kms_key" {
  source = "dod-iac/dynamodb-kms-key/aws"

  name = format("alias/app-%s-dynamodb-%s", var.application, var.environment)
  description = format("A KMS key used to encrypt data at rest in DynamoDB for %s:%s.", var.application, var.environment)
  principals_encrypt = [var.submit_lambda_execution_role_arn]
  principals_decrypt = [var.export_lambda_execution_role_arn, aws_iam_role.user.arn]
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 is not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | n/a | `string` | `"A KMS key used to encrypt data at rest stored in DynamoDB."` | no |
| key\_deletion\_window\_in\_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. | `string` | `30` | no |
| name | The display name of the alias. The name must start with the word "alias" followed by a forward slash (alias/). | `string` | `"alias/dynamodb"` | no |
| principals\_decrypt | AWS Principals that can decrypt using this KMS key. | `list(string)` | n/a | yes |
| principals\_encrypt | AWS Principals that can encrypt using this KMS key. | `list(string)` | n/a | yes |
| tags | Tags applied to the KMS key. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_kms\_alias\_arn | The Amazon Resource Name (ARN) of the key alias. |
| aws\_kms\_alias\_name | The display name of the alias. |
| aws\_kms\_key\_arn | The Amazon Resource Name (ARN) of the key. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
