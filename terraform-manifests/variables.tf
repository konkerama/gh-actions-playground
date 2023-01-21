# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

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
  type = string
}

variable "lambda-artifact-s3-bucket" {
  type = string
}

variable "lambda-artifact-s3-key" {
  type = string
}

variable "commit-id" {
  type    = string
  default = "latest"
}
