provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "lennakanhay"
  acl    = "private"
}

terraform {
  backend "s3" {
    bucket = "lennakanhay"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}



  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

resource "aws_instance" "app_server" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
