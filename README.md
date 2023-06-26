# terraform handson

ワークスペース初期化
```shell
terraform init
```

ファイル構文チェック
```shell
terraform validate
```

実行計画
```shell
terraform plan
```

リソースを作成

```shell
terraform apply
```


実行計画（削除）
```shell
terraform plan -destroy
```

リソースを削除
```shell
terraform destroy
```

## 参考

- [【Terraform入門】AWSのVPCとEC2を構築してみる](https://kacfg.com/terraform-vpc-ec2/)
- [How to generate SSH key in Terraform using tls_private_key?
  ](https://jhooq.com/terraform-generate-ssh-key/)
- [terraformでディレクトリごとにAWSアカウントを切り替える](https://zenn.dev/isosa/articles/fd9a9f92b68f6c)
- [TerraformでAWSのスポットインスタンスを作成する](https://qiita.com/m-shimao/items/0832d67b6abdc22ba2f0)
- [TerraformでtfstateをS3で管理する](https://techgrowup.net/2022/04/18/terraform%E3%81%A7tfstate%E3%82%92s3%E3%81%A7%E7%AE%A1%E7%90%86%E3%81%99%E3%82%8B/)