
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
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "this" {
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = local.az_a
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = aws_subnet.public_1a.id
  associate_public_ip_address = "true"
  key_name                    = local.key_name
  tags = {
    Name = "this"
  }
}