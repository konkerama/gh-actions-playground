
# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnets" "subnets_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}
data "aws_subnet" "subnet_id" {
  count = length(data.aws_subnets.subnets_ids.ids)
  id    = tolist(data.aws_subnets.subnets_ids.ids)[count.index]
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}