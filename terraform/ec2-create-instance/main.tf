provider "aws" {
  profile = "default"
  region  = var.aws_region
  assume_role {
    # This is a variable based on the AWS account
    role_arn     = var.jenkins_role_arn
    session_name = "terraform"
  }
}

resource "aws_instance" "clickhouse" {
  key_name             = var.keypair_name
  ami                  = var.ami_ids[each.value]
  instance_type        = var.clickhouse_machine_sizes[each.value]
  iam_instance_profile = data.aws_iam_instance_profile.clickhouse_profile.name
  subnet_id            = element(keys(var.subnet_clickhouse), index(keys(var.clickhouse_replicas), each.key))

#  user_data = filebase64("${path.module}/provision.sh")

  tags = {
    Name = var.instance_name
    Owner = "david"
  }

  root_block_device {
    volume_type = var.clickhouse_root_volume_type
    volume_size = var.clickhouse_root_volume_size
    //reliability: for prod purposes
    delete_on_termination = var.delete_root_disk_on_termination
    encrypted             = true
  }

  vpc_security_group_ids = [
    aws_security_group.clickhouse.id
  ]

}