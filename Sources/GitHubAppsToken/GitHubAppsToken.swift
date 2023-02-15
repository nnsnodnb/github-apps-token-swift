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
            version: "1.0.0",
            subcommands: []
        )
    }()

    @Argument(
        help: "アクセストークンの作成か取消を選択 (create or revoke)",
        transform: {
            guard let commandType = CommandType(rawValue: $0) else { throw CommandType.Error.unknown }
            return commandType
        }
    )
    private(set) var commandType: CommandType

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
        help: "権限が必要なリポジトリ",
        completion: .list([]),
        transform: { Repository(rawValue: $0) }
    )
    private(set) var repositories: [Repository]

    @Option(
        name: .long,
        help: "取り消しをするアクセストークン",
        transform: AccessToken.Token.init(rawValue:)
    )
    private(set) var accessToken: AccessToken.Token?
}

extension GitHubAppsToken {
    func run() async throws {
        let apiClient = APIClient()
        let jwtCreator = try JWTCreator(appID: appID, privateKey: privateKey)
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        let app = GitHubApps(jwtCreator: jwtCreator, githubAppsRepository: githubAppsRepository)

        switch commandType {
        case .create:
            // TODO: 修正
            let accessToken = try await app.accessToken(for: user, repositories: [], permission: .init())
            print(accessToken.token.rawValue)
        case .revoke:
            guard let accessToken else {
                // TODO: throw にする
                return
            }
            try await app.revokeAccessToken(accessToken)
        }
    }
}
