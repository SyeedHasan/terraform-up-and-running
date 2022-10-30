provider "aws" {
    region = "us-east-1"
}

variable "WEB_SERVER_PORT" {
  description = "Web server port used in the server's configuration and security groups"
  type = number
  default = 8080
}

resource "aws_instance" "MyInstance" {
    ami           = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
    tags = {
      "Name" = "TerraformBasicInstance"
    }
    user_data = <<-EOF
        #!/bin/bash
        echo "Hi there!" > index.html
        nohup busybox httpd -f -p ${var.WEB_SERVER_PORT} &
        EOF

    user_data_replace_on_change = true
    vpc_security_group_ids = [ aws_security_group.webserversg.id ]
}

resource "aws_security_group" "webserversg" {
    name = "web-server-access"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Opening 8080 to the Internet"
      from_port = var.WEB_SERVER_PORT
      protocol = "tcp"
      to_port = var.WEB_SERVER_PORT
    }
}

output "SERVER_IP" {
  description = "Web Server IP"
  value = aws_instance.MyInstance.public_ip
}