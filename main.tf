provider "aws" {
  region = "ap-northeast-1"
  shared_credentials_files = "[$HOME/.aws/credentials]"
}

# 自分のパブリックIP取得用
provider "http" {}
