resource "aws_vpc" "handson_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-handson-vpc"
  }
}

# -----------------
# Subnet
# -----------------
resource "aws_subnet" "handson_public_1a_sn" {
  vpc_id               = aws_vpc.handson_vpc.id
  cidr_block           = "10.0.1.0/24"
  availability_zone_id = var.az_a

  tags = {
    Name = "terraform-handson-public-1a-sn"
  }
}

# -----------------
# Internet Gateway
# -----------------
resource "aws_internet_gateway" "handson_igw" {
  vpc_id = aws_vpc.handson_vpc.id
  tags = {
    Name = "terraform-handson-igw"
  }
}

# -----------------
# Route table
# -----------------
resource "aws_route_table" "handson_public_rt" {
  vpc_id = aws_vpc.handson_vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.handson_igw.id
  }
  tags = {
    Name = "terraform-handson-public-rt"
  }
}

resource "aws_route_table_association" "handson_public_rt_associate" {
  subnet_id      = aws_subnet.handson_public_1a_sn.id
  route_table_id = aws_route_table_association.handson_public_rt_associate.id
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
  myip         = chomp(data.http.ifconfig.body)
  all_cidr     = "0.0.0.0/0"
  allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

resource "aws_security_group" "handson_ec2_sg" {
  name        = "terraform-handson-ec2-sg"
  description = "For EC2 Linux"
  vpc_id      = aws_vpc.handson_vpc.id
  tags = {
    Name = "terraform-handson-ec2-sg"
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


