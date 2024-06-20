# GitHubAppsToken

Command line tool to grant access tokens to each repository when needed via GitHub Apps.

## Installation

### [Mint](https://github.com/yonaskolb/Mint)

```command
mint install nnsnodnb/github-apps-token-swift
```

or add to `Mintfile`.

```
nnsnodnb/github-apps-token-swift@v1.1.3
```

### Manual

```command
git clone https://github.com/nnsnodnb/github-apps-token-swift.git
cd github-apps-token-swift
make release_build
```

Executable binary path is `.build/apple/Products/Release/github-apps-token` in repository directory.

## Usage

```command
$ github-apps-token --help
USAGE: github-apps-token <subcommand>

OPTIONS:
  --version               Show the version.
  --help                  Show help information.

SUBCOMMANDS:
  create                  Create an access token.
  revoke                  Revoke an access token.

  See 'github-apps-token help <subcommand>' for detailed help.
```

Choose the `create` and `revoke` subcommands for `github-apps-token`.

### Create an access token

```command
$ github-apps-token create --help
OVERVIEW: Create an access token.

USAGE: github-apps-token create [<options>] --app-id <app-id> --private-key <private-key> --proxy <proxy> --owner <owner> --repositories <repositories> ... --organization_self_hosted_runners <organization_self_hosted_runners>

OPTIONS:
  -a, --app-id <app-id>   The App ID of GitHub Apps.
  -p, --private-key <private-key>
                          The private key of GitHub Apps.
  -h, --host-url <host-url>
                          GitHub API Host URL. (default: https://api.github.com)
  -x, --proxy <proxy>     Your proxy server URL
  --owner <owner>         Owner of repositories
  -r, --repositories <repositories>
                          List of repositories that need permissions. (comma separated)
  --actions <actions>     The permission of actions.
  --administration <administration>
                          The permission of administration.
  --checks <checks>       The permission of checks.
  --contents <contents>   The permissions of contents.
  --deployments <deployments>
                          The permission of deployments.
  --environments <environments>
                          The permission of environments.
  --issues <issues>       The permission of issues.
  --metadata <metadata>   The permission of metadata.
  --packages <packages>   The permission of packages.
  --pages <pages>         The permission of pages.
  --pull_requests <pull_requests>
                          The permission of pull_requests.
  --repository_announcement_banners <repository_announcement_banners>
                          The permission of repository_announcement_banners.
  --repository_hooks <repository_hooks>
                          The permission of repository_hooks.
  --repository_projects <repository_projects>
                          The permission of repository_projects.
  --secret_scanning_alerts <secret_scanning_alerts>
                          The permission of secret_scanning_alerts.
  --secrets <secrets>     The permission of secrets.
  --security_events <security_events>
                          The permission of security_events.
  --single_file <single_file>
                          The permission of single_file.
  --statuses <statuses>   The permission of statuses.
  --vulnerability_alerts <vulnerability_alerts>
                          The permission of vulnerability_alers.
  --has-write-access-workflows
                          The write permission of workflows.
  --members <members>     The permission of members.
  --organization_administration <organization_administration>
                          The permission of organization_administration.
  --organization_custom_roles <organization_custom_roles>
                          The permission of organization_custom_roles.
  --organization_announcement_banners <organization_announcement_banners>
                          The permission of organization_announcement_banners.
  --organization_hooks <organization_hooks>
                          The permission of organization_hooks.
  --organization_plan     The read permission of organization_plan.
  --organization_projects <organization_projects>
                          The permission of organization_projects.
  --organization_packages <organization_packages>
                          The permission of organization_packages.
  --organization_secrets <organization_secrets>
                          The permission of organization_secrets.
  --organization_self_hosted_runners <organization_self_hosted_runners>
                          The permission of organization_self_hosted_runners.
  --organization_user_blocking <organization_user_blocking>
                          The permission of organization_user_blocking.
  --team_discussions <team_discussions>
                          The permission of team_discussions.
  --version               Show the version.
  --help                  Show help information.
```

<details>
<summary>Sample</summary>

Grants `your_github_username/repository_1` and `your_github_username/repository_2` read permission on `contents` and write permission on `pull_requests`.  
See [documentation](https://docs.github.com/en/rest/overview/permissions-required-for-github-apps?apiVersion=2022-11-28) for permissions.

```command
github-apps-token create \
  --app-id 123456 \
  --private-key /path/to/privatekey.pem \
  --owner your_github_username \
  --repositories repository_1 \
  --repositories repository_2 \
  --contents read \
  --pull_requests write
ghs_Hqu93EIWNm5HS8DPxuQiKABWOAsKlB3k6tYV
```

</details>

### Revoke an access token

```command
$ github-apps-token revoke --help
OVERVIEW: Revoke an access token.

USAGE: github-apps-token revoke [--host-url <host-url>] --proxy <proxy> --token <token>

OPTIONS:
  -h, --host-url <host-url>
                          GitHub API Host URL. (default: https://api.github.com)
  -x, --proxy <proxy>     Your proxy server URL
  -t, --token <token>     Access token to be revoked.
  --version               Show the version.
  --help                  Show help information.
```

<details>
<summary>Sample</summary>

```command
github-apps-token revoke --token ghs_Hqu93EIWNm5HS8DPxuQiKABWOAsKlB3k6tYV
```

</details>

## License

This software is licensed under the MIT License (See [LICENSE](LICENSE)).
