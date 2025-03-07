provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_dashboard" "example_dashboard" {
  dashboard_name = "MyDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 6
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", "i-0bd033d7bf9e70a01"]
          ]
          period     = 300
          stat       = "Average"
          region     = "us-east-1"
          title      = "EC2 CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = 6
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", "my-lambda-function"]
          ]
          period     = 60
          stat       = "Sum"
          region     = "us-east-1"
          title      = "Lambda Invocations"
        }
      }
    ]
  })
}       