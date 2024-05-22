// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubAppsToken",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "github-apps-token",
            targets: ["GitHubAppsTokenCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Get.git", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", .upToNextMajor(from: "4.13.4")),
        .package(url: "https://github.com/kateinoigakukun/StubKit.git", .upToNextMajor(from: "0.1.7")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.4.0")),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", .upToNextMajor(from: "0.10.0")),
    ],
    targets: [
        .executableTarget(
            name: "GitHubAppsTokenCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Entities",
                "GitHubAppsTokenCore",
            ]
        ),
        .target(
            name: "GitHubAppsTokenCore",
            dependencies: [
                .product(name: "Get", package: "Get"),
                .product(name: "JWTKit", package: "jwt-kit"),
                "Entities",
                "GitHubAppsAPI",
            ]
        ),
        .target(
            name: "Entities",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "GitHubAppsAPI",
            dependencies: [
                .product(name: "Get", package: "Get"),
                .product(name: "Tagged", package: "swift-tagged"),
                "Entities",
            ]
        ),
        .testTarget(
            name: "EntitiesTests",
            dependencies: [
                "Entities",
            ]
        ),
        .testTarget(
            name: "GitHubAppsTokenCLITests",
            dependencies: [
                "GitHubAppsTokenCLI",
            ]
        ),
        .testTarget(
            name: "GitHubAppsTokenCoreTests",
            dependencies: [
                .product(name: "StubKit", package: "StubKit"),
                "GitHubAppsAPI",
                "GitHubAppsTokenCore",
            ],
            resources: [.process("Resources")]
        ),
    ]
)
