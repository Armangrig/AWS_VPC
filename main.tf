terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#resource "aws_s3_bucket" "tf_state" {
#  bucket = "lennakanhay"
#  acl    = "public"
#}

terraform {
  backend "s3" {
    bucket = "lennakanhay"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}



resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1"
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id
  private_ips = ["10.0.0.10"]
}

#resource "aws_instance" "example" {
#  ami           = "ami-0c94855ba95c71c99"
#  instance_type = "t2.micro"
#  network_interface {
#    network_interface_id = aws_network_interface.example.id
#    device_index         = 0
#  }
#  
#  tags = {
#    Name = var.instance_name
#  }
#}
  
#}
resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  vpc_id      = aws_vpc.example.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = aws_network_interface.example.id
    device_index         = 0
  }
  
  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

#resource "aws_instance" "app_server" {
#  ami           = "ami-0b5eea76982371e91"
#  instance_type = "t2.micro"

#  tags = {
#    Name = var.instance_name
#  }
#}
