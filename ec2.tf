
# -----------------
# EC2 Key pair
# -----------------
variable "key_name" {
  default = "haryoiro-keypair"
}

resource "tls_private_key" "haryoiro_private_key" {
  algorithm = "ED25519"
}

locals {
  public_key_file  = "$HOME/${var.key_name}.id_ed25519.pub"
  private_key_file = "$HOME/${var.key_name}.id_ed25519"
}

resource "local_file" "haryoiro_private_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.haryoiro_private_key.private_key_pem
}

resource "aws_key_pair" "haryoiro_keypair" {
  key_name   = var.key_name
  public_key = tls_private_key.haryoiro_private_key.public_key_openssh
}

# -----------------
# EC2
# -----------------
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "haryoiro_ec2" {
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = var.az_a
  vpc_security_group_ids      = [aws_security_group.haryoiro_ec2_sg.id]
  subnet_id                   = aws_subnet.haryoiro_public_1a_sn.id
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  tags = {
    Name = "haryoiro-ec2"
  }
}