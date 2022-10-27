resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = var.aws_cloudwatch_log_group.name
  retention_in_days = var.aws_cloudwatch_log_group.retention_in_days
  tags = {
    Name = var.aws_cloudwatch_log_group.tags.Name
  }
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = var.aws_cloudwatch_log_stream.name
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
}