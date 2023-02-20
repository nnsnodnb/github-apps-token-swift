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

USAGE: github-apps-token create [<options>] --app-id <app-id> --private-key <private-key> --owner <owner> --repositories <repositories> ... --organization_self_hosted_runners <organization_self_hosted_runners>

OPTIONS:
  -a, --app-id <app-id>   GitHub AppsのアプリID
  -p, --private-key <private-key>
                          GitHub Appsの秘密鍵
  --owner <owner>         リポジトリの所有者
  -r, --repositories <repositories>
                          権限が必要なリポジトリのリスト
  --actions <actions>     actionsの権限
  --administration <administration>
                          administrationの権限
  --checks <checks>       checksの権限
  --contents <contents>   contentsの権限
  --deployments <deployments>
                          deploymentsの権限
  --environments <environments>
                          environmentsの権限
  --issues <issues>       issuesの権限
  --metadata <metadata>   metadataの権限
  --packages <packages>   packagesの権限
  --pages <pages>         pagesの権限
  --pull_requests <pull_requests>
                          pull_requestsの権限
  --repository_announcement_banners <repository_announcement_banners>
                          repository_announcement_bannersの権限
  --repository_hooks <repository_hooks>
                          repository_hooksの権限
  --repository_projects <repository_projects>
                          repository_projectsの権限
  --secret_scanning_alerts <secret_scanning_alerts>
                          secret_scanning_alertsの権限
  --secrets <secrets>     secretsの権限
  --security_events <security_events>
                          security_eventsの権限
  --single_file <single_file>
                          single_fileの権限
  --statuses <statuses>   statusesの権限
  --vulnerability_alerts <vulnerability_alerts>
                          vulnerability_alersの権限
  --has-write-access-workflows
                          workflowsの書き込み権限
  --members <members>     membersの権限
  --organization_administration <organization_administration>
                          organization_administrationの権限
  --organization_custom_roles <organization_custom_roles>
                          organization_custom_rolesの権限
  --organization_announcement_banners <organization_announcement_banners>
                          organization_announcement_bannersの権限
  --organization_hooks <organization_hooks>
                          organization_hooksの権限
  --organization_plan     organization_planの読み取り権限
  --organization_projects <organization_projects>
                          organization_projectsの権限
  --organization_packages <organization_packages>
                          organization_packagesの権限
  --organization_secrets <organization_secrets>
                          organization_secretsの権限
  --organization_self_hosted_runners <organization_self_hosted_runners>
                          organization_self_hosted_runnersの権限
  --organization_user_blocking <organization_user_blocking>
                          organization_user_blockingの権限
  --team_discussions <team_discussions>
                          team_discussionsの権限
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
    --contents read \
    --pull_requests write
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
