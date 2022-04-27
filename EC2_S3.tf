terraform {
  required_version = "0.15.0"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.36.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "ec2_name" {
  description = "Flugel"
}

variable "tag_owner" {
  description = "InfraTeam"
}

variable "bucket_name" {
  description = "Flugel"
}

resource "aws_instance" "test" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "test${var.ec2_name}"
    Owner = "test${var.tag_owner}"	
  }

resource "aws_s3_bucket" "Flugel" {
  bucket = "test${var.bucket_name}"
  versioning {
    enabled = true
	
	tags = {
    Owner = "test${var.bucket_name}"
  }
  }
}

output "ec2_tag" {
  value = aws_instance.test.tag
}

output "bucket_tag" {
  value = aws_s3_bucket.Flugel.tag
}

