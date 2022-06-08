variable "aws_region" {
  description = "Region where clickhouse must be installed"
}

variable "jenkins_role_arn" {
  description = "Role for the automation to be able to deploy the resources"
  default     = ""
}