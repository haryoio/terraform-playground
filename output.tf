output "ec2_global_ips" {
  value = aws_instance.this.*.public_ip
}
output "key" {
  sensitive = "true"
  value = local.keys
}