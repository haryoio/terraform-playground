
# -----------------
# EC2 Key pair
# -----------------
locals {
  key_name = "${local.project_name}keypair"
}

resource "tls_private_key" "private_key" {
  algorithm = "ED25519"
}

locals {
  public_key_file  = "~/${local.key_name}.id_ed25519.pub"
  private_key_file = "~/${local.key_name}.id_ed25519"
}

resource "local_file" "private_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.private_key.private_key_pem
}

resource "aws_key_pair" "keypair" {
  key_name   = local.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}


# -----------------
# EC2
# -----------------

locals {
  spot_instance_type = "t2.micro"
  spot_price         = "0.03"
  volume_size        = "100"
  volume_type        = "gp2"
}

data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ami" "amazonlinux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"

    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# -----------------
# FLEET
# -----------------
resource "aws_spot_fleet_request" "this" {
  iam_fleet_role                      = aws_iam_role.spot-fleet-role.arn
  target_capacity                     = 1
  terminate_instances_with_expiration = true
  wait_for_fulfillment                = "true"

  launch_specification {
    ami                         = data.aws_ami.amazonlinux_2.id
    instance_type               = local.spot_instance_type
    spot_price                  = local.spot_price
    key_name                    = aws_key_pair.keypair.key_name
    vpc_security_group_ids      = [aws_security_group.this.id]
    subnet_id                   = aws_subnet.public_1a.id
    associate_public_ip_address = true

    root_block_device {
      volume_size = local.volume_size
      volume_type = local.volume_type
    }

    tags = {
      Name = "${local.project_name}-spot-instance"
    }
  }
}

data "aws_instance" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.project_name}-spot-instance"]
  }

  depends_on = [aws_spot_fleet_request.this]
}
