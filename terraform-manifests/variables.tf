# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

# variable "s3_bucket" {
#   description = "S3 Bucket for storing artifacts & tfstate"
#   type        = string
# }

variable "resource_name" {
  description = "Naming convention for the AWS Resources to be created"
  type        = string
}

variable "environment" {
  description = "Naming convention for the AWS Resources to be created"
  type        = string
}

variable memory {
  type        = Number
  default     = "128"
}

