output "ec2_global_ips" {
  value = aws_instance.this.*.public_ip
}