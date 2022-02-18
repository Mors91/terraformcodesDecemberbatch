resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = join("-", [local.network.Environment, "dashboard"])

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "i-0176dd09f8ac33622"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "EC2 Instance CPU"
      }
    }
  ]
}
EOF
}

///Alarm

resource "aws_cloudwatch_metric_alarm" "devalarm" {
  alarm_name                = join("-", [local.network.Environment, "alarm"])
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ec2 cpu utilization"
#   insufficient_data_actions = []

  dimensions = {
      instanceid = aws_instance.ubuntuserver.id
  }
}