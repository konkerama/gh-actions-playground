module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  memory_size   = var.memory

  source_path = "../src/sample-function"

  tags = {
    Name = "my-lambda1"
  }
}
