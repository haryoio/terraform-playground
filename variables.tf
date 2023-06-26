data "aws_secretsmanager_secret" "porkbun_keys" {
  name = "PORKBUN_KEY"
}

data "aws_secretsmanager_secret_version" "porkbun_keys" {
  secret_id = data.aws_secretsmanager_secret.porkbun_keys.id
}

locals {
  project_name = "haryoiro"
  az_a         = "ap-northeast-1a"
  az_c         = "ap-northeast-1c"
  az_d         = "ap-northeast-1d"
  keys         = jsondecode(data.aws_secretsmanager_secret_version.porkbun_keys.secret_string)
}
