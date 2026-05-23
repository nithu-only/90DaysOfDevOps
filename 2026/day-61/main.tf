# 🔧 Terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = "us-east-1"  # Change if needed
}

# S3 Bucket (must be globally unique)
resource "aws_s3_bucket" "my_bucket" {
  bucket = "axata-terraform-bucket" 
  tags = {
    Name        = "MyFirstTerraformBucket"
    Environment = "Dev"
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-0c02fb55956c7d316" 
  instance_type = "t3.micro"

  tags = {
    Name = "TerraWeek-Modified"
  }
}