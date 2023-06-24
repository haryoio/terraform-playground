resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = local.project_name
  }
}

# -----------------
# Internet Gateway
# -----------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${local.project_name}-igw"
  }
}

# -----------------
# Public Subnet
# -----------------
resource "aws_subnet" "public_1a" {
  vpc_id               = aws_vpc.this.id
  cidr_block           = "10.0.1.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "${local.project_name}-public-1a"
  }
}

#resource "aws_subnet" "public_1c" {
#  vpc_id               = aws_vpc.this.id
#  cidr_block           = "10.0.2.0/24"
#  availability_zone = local.az_c
#
#  tags = {
#    Name = "${local.project_name}-public-1c"
#  }
#}
#
#resource "aws_subnet" "public_1d" {
#  vpc_id               = aws_vpc.this.id
#  cidr_block           = "10.0.2.0/24"
#  availability_zone = local.az_d
#
#  tags = {
#    Name = "${local.project_name}-public-1d"
#  }
#}

# -----------------
# Private Subnet
# -----------------
resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.10.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "${local.project_name}-private-1a"
  }
}

#resource "aws_subnet" "private_1c" {
#  vpc_id = aws_vpc.this.id
#  cidr_block = "10.0.10.0/24"
#  availability_zone = local.az_c
#
#  tags = {
#    Name = "${local.project_name}-private-1c"
#  }
#}
#
#resource "aws_subnet" "private_1d" {
#  vpc_id = aws_vpc.this.id
#  cidr_block = "10.0.10.0/24"
#  availability_zone = local.az_d
#
#  tags = {
#    Name = "${local.project_name}-private-1d"
#  }
#}


# -----------------
# Elastic IP
# -----------------
resource "aws_eip" "nat_1a" {
  domain = "vpc"
  tags = {
    Name = "${local.project_name}-eip-for-natgw-1a"
  }
}


# -----------------
# NAT Gateway
# -----------------
resource "aws_nat_gateway" "nat_1a" {
  subnet_id = aws_subnet.private_1a.id
  # 静的IPをNATに紐付ける
  allocation_id = aws_eip.nat_1a.id
  tags = {
    Name = "${local.project_name}-natgw-1a"
  }
}

# -----------------
# Public Subnet Route Table
# -----------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${local.project_name}-public"
  }
}

# -----------------
# Public Subnet Route Table Association
# -----------------
resource "aws_route_table_association" "public_1a_to_ig" {
  subnet_id = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

#resource "aws_route_table_association" "public_1c_to_ig" {
#  subnet_id = aws_subnet.private_1c.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "public_1d_to_ig" {
#  subnet_id = aws_subnet.private_1d.id
#  route_table_id = aws_route_table.public.id
#}



# -----------------
# Private Subnet Route Table
# -----------------
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = {
    Name = "${local.project_name}-private-1a"
  }
}

# -----------------
# Private Route Table Association
# -----------------
resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private_1a.id
  subnet_id = aws_subnet.private_1a.id
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
  self_ip      = chomp(data.http.ifconfig.response_body)
  all_cidr     = "0.0.0.0/0"
  allowed_cidr = (var.allowed_cidr == null) ? "${local.self_ip}/32" : var.allowed_cidr
}

resource "aws_security_group" "haryoiro_ec2_sg" {
  name        = "${local.project_name}-ec2-sg"
  description = "For EC2 Linux"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "${local.project_name}-ec2-sg"
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


