output "ec2_global_ips" {
  value = data.aws_instance.this.public_ip
  depends_on = [aws_spot_fleet_request.this]
}