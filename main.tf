#resource "aws_s3_bucket" "tf_state" {
#  bucket = "lennakanhay"
#  acl    = "private"
#}


provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "lennakanhay"
    key    = "terraform/emp"
    region = "us-east-1"
  }
  
  
#terraform {
#  backend "s3" {
#    bucket = "my-terraform-state"
#    key    = "state.tfstate"
#    region = "us-east-1"
#  }
#}
  
#  resource "aws_s3_bucket" "terraform_state" {
#  bucket = "lennakan"
#  force_destroy = true
#  versioning {
#    enabled = true
#  }
#}
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"

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
