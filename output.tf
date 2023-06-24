output "ec2_global_ips" {
  value = aws_instance.haryoiro_ec2.*.public_ip
}