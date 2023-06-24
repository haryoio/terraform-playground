resource "aws_vpc" "haryoiro_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "haryoiro-vpc"
  }
}

# -----------------
# Subnet
# -----------------
resource "aws_subnet" "haryoiro_public_1a_sn" {
  vpc_id               = aws_vpc.haryoiro_vpc.id
  cidr_block           = "10.0.1.0/24"
  availability_zone = var.az_a

  tags = {
    Name = "haryoiro-public-1a-sn"
  }
}

# -----------------
# Internet Gateway
# -----------------
resource "aws_internet_gateway" "haryoiro_igw" {
  vpc_id = aws_vpc.haryoiro_vpc.id
  tags = {
    Name = "haryoiro-igw"
  }
}

# -----------------
# Route table
# -----------------
resource "aws_route_table" "haryoiro_public_rt" {
  vpc_id = aws_vpc.haryoiro_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.haryoiro_igw.id
  }
  tags = {
    Name = "haryoiro-public-rt"
  }
}

resource "aws_route_table_association" "haryoiro_public_rt_associate" {
  subnet_id      = aws_subnet.haryoiro_public_1a_sn.id
  route_table_id = aws_route_table.haryoiro_public_rt.id
}


# -----------------
# Security Group
# -----------------
# 自分のパブリックIP取得
data "http" "ifconfig" {
  url = "https://ipv4.icanhazip.com/"
}

variable "allowed_cidr" {
  default = null
}

locals {
  self_ip         = chomp(data.http.ifconfig.response_body)
  all_cidr     = "0.0.0.0/0"
  allowed_cidr = (var.allowed_cidr == null) ? "${local.self_ip}/32" : var.allowed_cidr
}

resource "aws_security_group" "haryoiro_ec2_sg" {
  name        = "haryoiro-ec2-sg"
  description = "For EC2 Linux"
  vpc_id      = aws_vpc.haryoiro_vpc.id
  tags = {
    Name = "haryoiro-ec2-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.all_cidr]
  }
}


