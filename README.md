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
- [TerraformでtfstateファイルをS3で管理する](https://qiita.com/tsukakei/items/2751e245e38c814225f1)