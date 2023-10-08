resource "aws_cloudwatch_event_rule" "health_event_rule" {
  name          = "health_event_rule"
  description   = "Event rule for AWS Health events"
  event_pattern = <<EOF
{
  "source": ["aws.health"],
  "detail-type": ["AWS Health Event"],
  "detail": {
    "eventTypeCategory": ["issue"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.health_event_rule.name
  target_id = "send_to_lambda"
  arn = aws_lambda_function.health_event_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_event_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_event_rule.arn
}
