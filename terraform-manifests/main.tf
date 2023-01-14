module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.resource_name}-${var.environment}"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  memory_size   = var.memory

  environment_variables = {
    ENV = var.environment
    URL = var.url
  }

  create_package = false
  s3_existing_package = {
    bucket = var.lambda-artifact-s3-bucket
    key    = var.lambda-artifact-s3-key
  }


  # var.resource_name

  # source_path = "../src/sample-function"

  tags = {
    Name = "my-lambda1"
  }
}
