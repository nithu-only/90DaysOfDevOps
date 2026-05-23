terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

############################
# PROVIDER
############################
provider "aws" {
  region = var.region
}

############################
# LOCALS (TASK 5 ENHANCED)
############################
locals {
  # naming convention using expressions
  name_prefix = lower("${var.project_name}-${var.environment}")

  # dynamic environment-based configuration
  is_prod = var.environment == "prod"

  # common tags applied everywhere
  common_tags = merge(var.extra_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  # compute-friendly instance naming
  instance_name = "${local.name_prefix}-ec2"

  # S3 bucket naming with uniqueness logic
  bucket_name = "${local.name_prefix}-logs-${random_id.suffix.hex}"
}

############################
# DATA SOURCES
############################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {}

############################
# VPC
############################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

############################
# SUBNET
############################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet"
  })
}

############################
# INTERNET GATEWAY
############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

############################
# ROUTE TABLE
############################
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rt"
  })
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

############################
# SECURITY GROUP
############################
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  name = "${local.name_prefix}-sg"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg"
  })
}

############################
# EC2 INSTANCE (USES LOCALS)
############################
resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = local.instance_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

############################
# RANDOM ID
############################
resource "random_id" "suffix" {
  byte_length = 4
}

############################
# S3 BUCKET (USING LOCALS)
############################
resource "aws_s3_bucket" "logs" {
  bucket = local.bucket_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-logs"
  })

  depends_on = [aws_instance.main]
}