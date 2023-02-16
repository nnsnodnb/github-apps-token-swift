# GitHubAppsToken

GitHub Apps を通じて必要なときにアクセストークンをリポジトリごとに付与するコマンドラインツール

## Usage

```command
$ github-apps-token --help
USAGE: github-apps-token <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  create                  アクセストークンを作成します
  revoke                  アクセストークンを取り消します

  See 'github-apps-token help <subcommand>' for detailed help.
```

`github-apps-token` に `create` と `revoke` のサブコマンドを選択します

### アクセストークンの生成

```command
$ github-apps-token create --help
OVERVIEW: アクセストークンを作成します

USAGE: github-apps-token create --app-id <app-id> --private-key <private-key> --user <user> --repositories <repositories> ... [--write <write> ...] [--read <read> ...]

OPTIONS:
  -a, --app-id <app-id>   GitHub AppsのアプリID
  -p, --private-key <private-key>
                          GitHub Appsの秘密鍵
  -u, --user <user>       GitHubユーザ名
  -r, --repositories <repositories>
                          権限が必要なリポジトリのリスト
  --write <write>         書き込みが必要な権限のリスト
  --read <read>           読み込みが必要な権限のリスト
  --version               Show the version.
  -h, --help              Show help information.
```

<details>
<summary>サンプル</summary>

`your_github_username/repository_1` と `your_github_username/repository_2` に `contents` の読み取り権限， `pull_requests` に書き込み権限を与える  
権限については[ドキュメント](https://docs.github.com/en/rest/overview/permissions-required-for-github-apps?apiVersion=2022-11-28)を参照

```command
$ github-apps-token create \
    --app-id 123456 \
    --private-key /path/to/privatekey.pem \
    --user your_github_username \
    --repositories repository_1 \
    --repositories repository_2 \
    --read contents \
    --write pull_requests
ghs_Hqu93EIWNm5HS8DPxuQiKABWOAsKlB3k6tYV
```

</details>

### アクセストークンの取り消し

```command
$ github-apps-token revoke --help
OVERVIEW: アクセストークンを取り消します

USAGE: github-apps-token revoke --token <token>

OPTIONS:
  -t, --token <token>     取り消すアクセストークン
  --version               Show the version.
  -h, --help              Show help information.
```

<details>
<summary>サンプル</summary>

```command
$ github-apps-token revoke --token ghs_Hqu93EIWNm5HS8DPxuQiKABWOAsKlB3k6tYV
```

</details>
