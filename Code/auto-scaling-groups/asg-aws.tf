provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "defaultVpc" {
    default = true
}

data "aws_subnets" "defaultSubnets" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.defaultVpc.id]
    }
}

variable "WEB_SERVER_PORT" {
  description = "Web server port used in the server's configuration and security groups"
  type = number
  default = 8080
}

variable "LB_PORT" {
    type = number
    default = 80
}

resource "aws_launch_configuration" "LaunchConfig" {
    ami           = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
    user_data_replace_on_change = true
    vpc_security_group_ids = [ aws_security_group.webserversg.id ]
    user_data = <<-EOF
        #!/bin/bash
        echo "Hi there!" > index.html
        nohup busybox httpd -f -p ${var.WEB_SERVER_PORT} &
        EOF
    
    tags = {
      "Name" = "TerraformBasicInstance"
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "MyASG" {
    launch_configuration = aws_launch_configuration.LaunchConfig
    vpc_zone_identifier = data.aws_subnets.defaultSubnets.ids
    min_size = 2
    max_size = 5

    tag {
      key = "Nam"
      Value = "Terraform'ed ASG"
      propagate_at_launch = true
    }
}

resource "aws_lb" "ApplicationLb" {
    name = "Terraform LB"
    load_balancer_type = "application"
    subnets = data.aws_subnets.defaultSubnets.ids  
    security_groups = [aws_security_group.OpenWebAccess.id]
}

resource "aws_lb_listener" "LbListenerGroup" {
    load_balancer_arn = aws_lb.ApplicationLb.arn
    port = var.LB_PORT
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "404: What'd you do, Mark?"
        status_code = 404
      }
    }
}

resource "aws_lb_target_group" "LbTargetGroup" {
    name = "TerraformASG TargetGroup"
    port = var.WEB_SERVER_PORT
    protocol = "HTTP"
    vpc_id = data.aws_vpc.defaultVpc.id

    health_check {
      path = "/"
      protocl = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_security_group" "OpenWebAccess" {
    name = "lb-web-access-sg"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = var.LB_PORT
      protocol = "tcp"
      to_port = var.LB_PORT
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}