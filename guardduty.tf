resource "aws_guardduty_detector" "guardDuty_detector" {
  enable = true

  tags = {
    Name = "${var.application_name} GuardDuty Detector"
  }
}