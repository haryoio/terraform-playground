terraform {
  required_providers {
    porkbun = {
      source = "cullenmcdermott/porkbun"
      version = "0.2.0"
    }
  }
}

provider "aws" {
  region                   = "ap-northeast-1"
  shared_credentials_files = ["$HOME/.aws/credentials"]
}

# 自分のパブリックIP取得用
provider "http" {}

provider "porkbun" {
  api_key = local.keys["API_KEY"]
}