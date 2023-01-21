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
