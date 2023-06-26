resource "porkbun_dns_record" "this" {
  domain = "haryoiro.com"
  name = "a"
  type = "A"
  content = data.aws_instance.this.public_ip
  ttl = 600
}