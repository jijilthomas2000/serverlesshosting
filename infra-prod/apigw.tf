resource "aws_apigatewayv2_api" "visitor" {
  name          = "visitor_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.visitor.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.visitor.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "visitor_route" {
  api_id    = aws_apigatewayv2_api.visitor.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitor.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.visitor.id
  name        = var.environment
  auto_deploy = true
}

output "backend_api_url" {
  value = "${aws_apigatewayv2_stage.dev.invoke_url}/"
}
