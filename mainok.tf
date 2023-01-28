terraform {
  backend "s3" {
    bucket = "lennagan"
    key    = "terraform/emportant"
    region = "us-east-1"
  }

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

resource "aws_vpc" "first_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "${var.task_name}_vpc"
  }
}

resource "aws_internet_gateway" "first_ig" { ###############
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "${var.task_name}_internet_gateway"
  }
}

resource "aws_route_table" "first_route_table" { #################
  vpc_id = aws_vpc.first_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.first_ig.id
  }

  tags = {
    Name = "${var.task_name}_route_table"
  }
}

resource "aws_route_table_association" "a" { ##############
  subnet_id      = aws_subnet.first_public_subnet.id
  route_table_id = aws_route_table.first_route_table.id
}

resource "aws_subnet" "first_public_subnet" {
  vpc_id                  = aws_vpc.first_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone = "us-east-1a" ##################
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.task_name}_public_subnet"
  }
}

resource "aws_security_group" "first_security_group" {
  name   = "${var.task_name}_security_group"
  vpc_id = aws_vpc.first_vpc.id

  ingress {
    description = "allow expose the 80 port to the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.task_name}_security_group"
  }
}

resource "aws_network_interface" "first_network_interface" {
  subnet_id       = aws_subnet.first_public_subnet.id
  private_ips     = ["192.168.1.10"]
  security_groups = [aws_security_group.first_security_group.id]

  # attachment {
  #   instance     = aws_instance.first_aws_instance.id
  #   device_index = 1
  # }

  tags = {
    Name = "${var.task_name}_network_interface"
  }
}

resource "aws_instance" "first_aws_instance" {
  ami                    = "ami-0b5eea76982371e91"
  instance_type          = var.instance_type
  availability_zone = "us-east-1a" ##############
  # vpc_security_group_ids = [aws_security_group.first_security_group.id]
  # subnet_id              = aws_subnet.first_public_subnet.id
  user_data = file("user_data.sh")

  network_interface { ###############################
    device_index         = 0
    network_interface_id = aws_network_interface.first_network_interface.id
  }

  tags = {
    Name = "${var.task_name}_instance"
  }
}
