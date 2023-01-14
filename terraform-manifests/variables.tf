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

variable "memory" {
  type    = number
  default = "128"
}

variable "url" {
  type    = string
}

variable "lambda-artifact-s3-bucket"{
  type    = string
  default = "to-be-overridden"
}

variable "lambda-artifact-s3-key"{
  type    = string
  default = "to-be-overridden"
}

