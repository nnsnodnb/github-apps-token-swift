import ArgumentParser
import Entities
import Foundation
import GitHubApps
import GitHubInstallation

@main
struct GitHubAppsTokenCLI: AsyncParsableCommand {
    // MARK: - Properties
    static var configuration: CommandConfiguration = {
        .init(
            commandName: "github-apps-token",
            version: GitHubApps.version,
            subcommands: [Create.self, Revoke.self]
        )
    }()
}

// MARK: - Subcommand
extension GitHubAppsTokenCLI {
    struct Create: AsyncParsableCommand {
        // MARK: - Properties
        static let configuration: CommandConfiguration = .init(abstract: "アクセストークンを作成します")

        @Option(
            name: .shortAndLong,
            help: "GitHub AppsのアプリID"
        )
        private(set) var appID: String

        @Option(
            name: .shortAndLong,
            help: "GitHub Appsの秘密鍵",
            completion: .file(extensions: ["pem"]),
            transform: URL.init(fileURLWithPath:)
        )
        private(set) var privateKey: URL

        @Option(
            name: .long,
            help: "リポジトリの所有者"
        )
        private(set) var owner: String

        @Option(
            name: .shortAndLong,
            help: "権限が必要なリポジトリのリスト",
            completion: .list([]),
            transform: Repository.init(rawValue:)
        )
        private(set) var repositories: [Repository]

        @Option(
            name: .long,
            help: "actionsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var actions: Permission.Level?

        @Option(
            name: .long,
            help: "administrationの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var administration: Permission.Level?

        @Option(
            name: .long,
            help: "checksの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var checks: Permission.Level?

        @Option(
            name: .long,
            help: "contentsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var contents: Permission.Level?

        @Option(
            name: .long,
            help: "deploymentsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var deployments: Permission.Level?

        @Option(
            name: .long,
            help: "environmentsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var environments: Permission.Level?

        @Option(
            name: .long,
            help: "issuesの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var issues: Permission.Level?

        @Option(
            name: .long,
            help: "metadataの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var metadata: Permission.Level?

        @Option(
            name: .long,
            help: "packagesの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var packages: Permission.Level?

        @Option(
            name: .long,
            help: "pagesの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var pages: Permission.Level?

        @Option(
            name: .customLong("pull_requests"),
            help: "pull_requestsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var pullRequests: Permission.Level?

        @Option(
            name: .customLong("repository_announcement_banners"),
            help: "repository_announcement_bannersの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var repositoryAnnouncementBanners: Permission.Level?

        @Option(
            name: .customLong("repository_hooks"),
            help: "repository_hooksの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var repositoryHooks: Permission.Level?

        @Option(
            name: .customLong("repository_projects"),
            help: "repository_projectsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var repositoryProjects: Permission.Level?

        @Option(
            name: .customLong("secret_scanning_alerts"),
            help: "secret_scanning_alertsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: false) }
        )
        private(set) var secretScanningAlerts: Permission.Level?

        @Option(
            name: .customLong("secrets"),
            help: "secretsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var secrets: Permission.Level?

        @Option(
            name: .customLong("security_events"),
            help: "security_eventsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var securityEvents: Permission.Level?

        @Option(
            name: .customLong("single_file"),
            help: "single_fileの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var singleFile: Permission.Level?

        @Option(
            name: .customLong("statuses"),
            help: "statusesの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var statuses: Permission.Level?

        @Option(
            name: .customLong("vulnerability_alerts"),
            help: "vulnerability_alersの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var vulnerabilityAlerts: Permission.Level?

        @Flag(
            name: .long,
            help: "workflowsの書き込み権限"
        )
        private(set) var hasWriteAccessWorkflows = false

        @Option(
            name: .customLong("members"),
            help: "membersの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var members: Permission.Level?

        @Option(
            name: .customLong("organization_administration"),
            help: "organization_administrationの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationAdministration: Permission.Level?

        @Option(
            name: .customLong("organization_custom_roles"),
            help: "organization_custom_rolesの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationCustomRoles: Permission.Level?

        @Option(
            name: .customLong("organization_announcement_banners"),
            help: "organization_announcement_bannersの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationAnnouncementBanners: Permission.Level?

        @Option(
            name: .customLong("organization_hooks"),
            help: "organization_hooksの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationHooks: Permission.Level?

        @Flag(
            name: .customLong("organization_plan"),
            help: "organization_planの読み取り権限"
        )
        private(set) var hasReadAccessOrganizationPlan = false

        @Option(
            name: .customLong("organization_projects"),
            help: "organization_projectsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: false) }
        )
        private(set) var organizationProjects: Permission.Level?

        @Option(
            name: .customLong("organization_packages"),
            help: "organization_packagesの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationPackages: Permission.Level?

        @Option(
            name: .customLong("organization_secrets"),
            help: "organization_secretsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationSecrets: Permission.Level?

        @Option(
            name: .customLong("organization_self_hosted_runners"),
            help: "organization_self_hosted_runnersの権限",
            transform: Permission.Level.init(rawValue:)
        )
        private(set) var organizationSelfHostedRunners: Permission.Level?

        @Option(
            name: .customLong("organization_user_blocking"),
            help: "organization_user_blockingの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationUserBlocking: Permission.Level?

        @Option(
            name: .customLong("team_discussions"),
            help: "team_discussionsの権限",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var teamDiscussions: Permission.Level?
    }

    struct Revoke: AsyncParsableCommand {
        // MARK: - Properties
        static let configuration: CommandConfiguration = .init(abstract: "アクセストークンを取り消します")

        @Option(
            name: [.customShort("t"), .customLong("token")],
            help: "取り消すアクセストークン",
            transform: AccessToken.Token.init(rawValue:)
        )
        private(set) var acccessToken: AccessToken.Token
    }
}

// MARK: - Create
extension GitHubAppsTokenCLI.Create {
    func run() async throws {
        let jwtGenerator = try JWTGenerator(appID: appID, privateKey: privateKey)
        let apiClient = APIClient()
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        let apps = GitHubApps(jwtGenerator: jwtGenerator, githubAppsRepository: githubAppsRepository)
        let permission = makePermission()

        let accessToken = try await apps.createAccessToken(for: owner, repositories: repositories, permission: permission)
        print(accessToken.token.rawValue)
    }

    private func makePermission() -> Permission {
        return Permission(
            actions: actions,
            administration: administration,
            checks: checks,
            contents: contents,
            deployments: deployments,
            environments: environments,
            issues: issues,
            packages: packages,
            pages: pages,
            pullRequests: pullRequests,
            repositoryAnnouncementBanners: repositoryAnnouncementBanners,
            repositoryHooks: repositoryHooks,
            repositoryProjects: repositoryProjects,
            secretScanningAlerts: secretScanningAlerts,
            secrets: secrets,
            securityEvents: securityEvents,
            singleFile: singleFile,
            statuses: statuses,
            vulnerabilityAlerts: vulnerabilityAlerts,
            workflows: hasWriteAccessWorkflows ? .write : nil,
            members: members,
            organizationAdministration: organizationAdministration,
            organizationCustomRoles: organizationCustomRoles,
            organizationAnnouncementBanners: organizationAnnouncementBanners,
            organizationHooks: organizationHooks,
            organizationPlan: hasReadAccessOrganizationPlan ? .read : nil,
            organizationProjects: organizationProjects,
            organizationPackages: organizationPackages,
            organizationSecrets: organizationSecrets,
            organizationSelfHostedRunners: organizationSelfHostedRunners,
            organizationUserBlocking: organizationUserBlocking,
            teamDiscussions: teamDiscussions
        )
    }
}

// MARK: - Revoke
extension GitHubAppsTokenCLI.Revoke {
    func run() async throws {
        let apiClient = APIClient()
        let githubInstallationRepository = GitHubInstallationRepository(apiClient: apiClient)
        let installation = GitHubInstallation(githubInstallationRepository: githubInstallationRepository)
        try await installation.revokeAccessToken(acccessToken)
    }
}
