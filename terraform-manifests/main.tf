module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.resource_name}-${var.environment}"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  memory_size   = var.memory

  environment_variables = {
    ENV = var.environment
  }


  source_path = "../src/sample-function"

  tags = {
    Name = "my-lambda1"
  }
}
