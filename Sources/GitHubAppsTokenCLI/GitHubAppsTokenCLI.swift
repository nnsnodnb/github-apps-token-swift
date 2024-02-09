import ArgumentParser
import Entities
import Foundation
import GitHubAppsTokenCore

@main
struct GitHubAppsTokenCLI: AsyncParsableCommand {
    // MARK: - Properties
    static var configuration: CommandConfiguration = {
        .init(
            commandName: "github-apps-token",
            version: Runner.version,
            subcommands: [Create.self, Revoke.self],
            helpNames: .long
        )
    }()
}

// MARK: - Subcommand
extension GitHubAppsTokenCLI {
    struct Create: AsyncParsableCommand {
        // MARK: - Properties
        static let configuration: CommandConfiguration = .init(abstract: "Create an access token.")

        @Option(
            name: .shortAndLong,
            help: "The App ID of GitHub Apps."
        )
        private(set) var appID: String

        @Option(
            name: .shortAndLong,
            help: "The private key of GitHub Apps.",
            completion: .file(extensions: ["pem"]),
            transform: URL.init(fileURLWithPath:)
        )
        private(set) var privateKey: URL

        @Option(
            name: .shortAndLong,
            help: "GitHub API Host URL. (default: https://api.github.com)",
            transform: URL.init(string:)
        )
        private(set) var hostURL: URL? = URL(string: "https://api.github.com")

        @Option(
            name: .long,
            help: "Owner of repositories"
        )
        private(set) var owner: String

        @Option(
            name: .shortAndLong,
            help: "List of repositories that need permissions.",
            completion: .list([]),
            transform: Repository.init(rawValue:)
        )
        private(set) var repositories: [Repository]

        @Option(
            name: .long,
            help: "The permission of actions.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var actions: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of administration.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var administration: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of checks.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var checks: Permission.Level?

        @Option(
            name: .long,
            help: "The permissions of contents.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var contents: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of deployments.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var deployments: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of environments.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var environments: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of issues.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var issues: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of metadata.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var metadata: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of packages.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var packages: Permission.Level?

        @Option(
            name: .long,
            help: "The permission of pages.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var pages: Permission.Level?

        @Option(
            name: .customLong("pull_requests"),
            help: "The permission of pull_requests.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var pullRequests: Permission.Level?

        @Option(
            name: .customLong("repository_announcement_banners"),
            help: "The permission of repository_announcement_banners.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var repositoryAnnouncementBanners: Permission.Level?

        @Option(
            name: .customLong("repository_hooks"),
            help: "The permission of repository_hooks.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var repositoryHooks: Permission.Level?

        @Option(
            name: .customLong("repository_projects"),
            help: "The permission of repository_projects.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var repositoryProjects: Permission.Level?

        @Option(
            name: .customLong("secret_scanning_alerts"),
            help: "The permission of secret_scanning_alerts.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: false) }
        )
        private(set) var secretScanningAlerts: Permission.Level?

        @Option(
            name: .customLong("secrets"),
            help: "The permission of secrets.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var secrets: Permission.Level?

        @Option(
            name: .customLong("security_events"),
            help: "The permission of security_events.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var securityEvents: Permission.Level?

        @Option(
            name: .customLong("single_file"),
            help: "The permission of single_file.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var singleFile: Permission.Level?

        @Option(
            name: .customLong("statuses"),
            help: "The permission of statuses.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var statuses: Permission.Level?

        @Option(
            name: .customLong("vulnerability_alerts"),
            help: "The permission of vulnerability_alers.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var vulnerabilityAlerts: Permission.Level?

        @Flag(
            name: .long,
            help: "The write permission of workflows."
        )
        private(set) var hasWriteAccessWorkflows = false

        @Option(
            name: .customLong("members"),
            help: "The permission of members.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var members: Permission.Level?

        @Option(
            name: .customLong("organization_administration"),
            help: "The permission of organization_administration.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationAdministration: Permission.Level?

        @Option(
            name: .customLong("organization_custom_roles"),
            help: "The permission of organization_custom_roles.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationCustomRoles: Permission.Level?

        @Option(
            name: .customLong("organization_announcement_banners"),
            help: "The permission of organization_announcement_banners.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationAnnouncementBanners: Permission.Level?

        @Option(
            name: .customLong("organization_hooks"),
            help: "The permission of organization_hooks.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationHooks: Permission.Level?

        @Flag(
            name: .customLong("organization_plan"),
            help: "The read permission of organization_plan."
        )
        private(set) var hasReadAccessOrganizationPlan = false

        @Option(
            name: .customLong("organization_projects"),
            help: "The permission of organization_projects.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: false) }
        )
        private(set) var organizationProjects: Permission.Level?

        @Option(
            name: .customLong("organization_packages"),
            help: "The permission of organization_packages.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationPackages: Permission.Level?

        @Option(
            name: .customLong("organization_secrets"),
            help: "The permission of organization_secrets.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationSecrets: Permission.Level?

        @Option(
            name: .customLong("organization_self_hosted_runners"),
            help: "The permission of organization_self_hosted_runners.",
            transform: Permission.Level.init(rawValue:)
        )
        private(set) var organizationSelfHostedRunners: Permission.Level?

        @Option(
            name: .customLong("organization_user_blocking"),
            help: "The permission of organization_user_blocking.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var organizationUserBlocking: Permission.Level?

        @Option(
            name: .customLong("team_discussions"),
            help: "The permission of team_discussions.",
            transform: { try Permission.Level.init(rawValue: $0, withoutAdmin: true) }
        )
        private(set) var teamDiscussions: Permission.Level?
    }

    struct Revoke: AsyncParsableCommand {
        // MARK: - Properties
        static let configuration: CommandConfiguration = .init(abstract: "Revoke an access token.")

        @Option(
            name: .shortAndLong,
            help: "GitHub API Host URL. (default: https://api.github.com)",
            transform: URL.init(string:)
        )
        private(set) var hostURL: URL? = URL(string: "https://api.github.com")

        @Option(
            name: [.customShort("t"), .customLong("token")],
            help: "Access token to be revoked.",
            transform: AccessToken.Token.init(rawValue:)
        )
        private(set) var accessToken: AccessToken.Token
    }
}

// MARK: - Create
extension GitHubAppsTokenCLI.Create {
    func run() async throws {
        let apiClient = APIClient(baseURL: hostURL)
        let runner = Runner(apiClient: apiClient)
        let token = try await runner.create(
            appID: appID,
            privateKey: privateKey,
            owner: owner,
            repositories: repositories,
            permission: makePermission()
        )
        print(token.rawValue)

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
        let apiClient = APIClient(baseURL: hostURL)
        let runner = Runner(apiClient: apiClient)
        try await runner.revoke(with: accessToken)
    }
}
