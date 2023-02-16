import ArgumentParser
import Entities
import Foundation
import GitHubApps

@main
struct GitHubAppsToken: AsyncParsableCommand {
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
extension GitHubAppsToken {
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
            name: .shortAndLong,
            help: "GitHubユーザ名"
        )
        private(set) var user: String

        @Option(
            name: .shortAndLong,
            help: "権限が必要なリポジトリのリスト",
            completion: .list([]),
            transform: Repository.init(rawValue:)
        )
        private(set) var repositories: [Repository]

        @Option(
            name: .long,
            help: "書き込みが必要な権限のリスト",
            completion: .list([]),
            transform: {
                guard let permissionType = PermissionType(rawValue: $0) else { throw PermissionType.Error.unknown }
                return permissionType
            }
        )
        private(set) var write: [PermissionType] = []

        @Option(
            name: .long,
            help: "読み込みが必要な権限のリスト",
            completion: .list([]),
            transform: {
                guard let permissionType = PermissionType(rawValue: $0) else { throw PermissionType.Error.unknown }
                return permissionType
            }
        )
        private(set) var read: [PermissionType] = []
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
extension GitHubAppsToken.Create {
    func run() async throws {
        let jwtGenerator = try JWTGenerator(appID: appID, privateKey: privateKey)
        let apiClient = APIClient()
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        let apps = GitHubApps(jwtGenerator: jwtGenerator, githubAppsRepository: githubAppsRepository)
        let permission = makePermission()

        let accessToken = try await apps.createAccessToken(for: user, repositories: repositories, permission: permission)
        print(accessToken.token.rawValue)
    }

    private func makePermission() -> Permission {
        // permission
        let readOnly = read.filter { !write.contains($0) }
        // contents
        let contents: Permission.Level?
        if write.contains(.contents) {
            contents = .write
        } else if readOnly.contains(.contents) {
            contents = .read
        } else {
            contents = nil
        }
        // statuses
        let statuses: Permission.Level?
        if write.contains(.statuses) {
            statuses = .write
        } else if readOnly.contains(.statuses) {
            statuses = .read
        } else {
            statuses = nil
        }
        // pull_requests
        let pullRequests: Permission.Level?
        if write.contains(.pullRequests) {
            pullRequests = .write
        } else if readOnly.contains(.pullRequests) {
            pullRequests = .read
        } else {
            pullRequests = nil
        }
        // issues
        let issues: Permission.Level?
        if write.contains(.issues) {
            issues = .write
        } else if readOnly.contains(.issues) {
            issues = .read
        } else {
            issues = nil
        }

        let permission = Permission(
            contents: contents,
            statuses: statuses,
            pullRequests: pullRequests,
            issues: issues
        )
        return permission
    }
}

// MARK: - Revoke
extension GitHubAppsToken.Revoke {
    func run() async throws {
        let apiClient = APIClient()
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        try await githubAppsRepository.revokeAccessToken(acccessToken)
    }
}
