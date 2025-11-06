resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_ddb" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "visitor" {
  filename         = "${path.module}/lambda/visitor.zip"
  function_name    = "visitor_counter"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "visitor.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("${path.module}/lambda/visitor.zip")

  environment {
  variables = {
    ENVIRONMENT = var.environment
  }
}

}
