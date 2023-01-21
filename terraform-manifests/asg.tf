resource "aws_autoscaling_group" "example" {
  depends_on = [
    aws_cloudwatch_log_group.ec2_log_group
  ]
  #   availability_zones = ["us-east-1a"]
  vpc_zone_identifier = data.aws_subnet.subnet_id.*.id
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }

  #   tag {
  #     key                 = "Key"
  #     value               = "Value"
  #     propagate_at_launch = true
  #   }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

data "template_file" "init" {
  template = file("${path.module}/../src/sample-container/server/ec2_user_data.sh")
  vars = {
    commit_id = "${var.commit-id}"
    env       = "dev"
    log_group = "/aws/ec2/${var.resource_name}-${var.environment}"
  }
}

resource "aws_launch_template" "example" {
  image_id      = data.aws_ami.amzlinux2.id
  instance_type = "t3.nano"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  user_data = base64encode(data.template_file.init.rendered)

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}


resource "aws_iam_role" "ec2_iam_role" {
  name = "${var.resource_name}-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:GetObject"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["ssm:*", "ec2:*", "lambda:*", "logs:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.resource_name}-iam-instance-profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.resource_name}-${var.environment}-sg"
  description = "Security Group for ${var.resource_name}"
  vpc_id      = data.aws_vpc.vpc.id
}

# resource "aws_security_group_rule" "example" {
#   count = var.connect_to_instance ? 1 : 0

#   type              = "ingress"
#   from_port         = 8384
#   to_port           = 8384
#   protocol          = "tcp"
#   description       = "syncthing-gui"
#   cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
#   security_group_id = aws_security_group.ec2_sg.id
# }

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "allow_ingress" {
  type              = "ingress"
  to_port           = 5000
  protocol          = "-1"
  from_port         = 5000
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/aws/ec2/${var.resource_name}-${var.environment}"
  retention_in_days = 14
}