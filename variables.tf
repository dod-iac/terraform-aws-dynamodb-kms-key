variable "description" {
  type        = string
  description = ""
  default     = "A KMS key used to encrypt data at rest stored in DynamoDB."
}

variable "key_deletion_window_in_days" {
  type        = string
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days."
  default     = 30
}

variable "name" {
  type        = string
  description = "The display name of the alias. The name must start with the word \"alias\" followed by a forward slash (alias/)."
  default     = "alias/dynamodb"
}

variable "principals_decrypt" {
  type        = list(string)
  description = "AWS Principals that can decrypt using this KMS key."
}

variable "principals_encrypt" {
  type        = list(string)
  description = "AWS Principals that can encrypt using this KMS key."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the KMS key."
  default     = {}
}
