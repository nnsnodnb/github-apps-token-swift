// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubAppsToken",
    products: [
        .executable(
            name: "github-apps-token",
            targets: ["GitHubAppsToken"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ishkawa/APIKit.git", .upToNextMajor(from: "5.4.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", .upToNextMajor(from: "4.8.0")),
        .package(url: "https://github.com/kateinoigakukun/StubKit.git", .upToNextMajor(from: "0.1.7")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", .upToNextMajor(from: "0.10.0")),
    ],
    targets: [
        .executableTarget(
            name: "GitHubAppsToken",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "GitHubApps",
            ]
        ),
        .target(
            name: "Entities",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "GitHubApps",
            dependencies: [
                .product(name: "APIKit", package: "APIKit"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "StubKit", package: "StubKit"),
                "Entities",
                "GitHubAppsAPI",
            ]
        ),
        .target(
            name: "GitHubAppsAPI",
            dependencies: [
                .product(name: "APIKit", package: "APIKit"),
                .product(name: "Tagged", package: "swift-tagged"),
                "Entities",
            ]
        ),
        .testTarget(
            name: "GitHubAppsTokenTests",
            dependencies: ["GitHubAppsToken"]
        ),
        .testTarget(
            name: "GitHubAppsTests",
            dependencies: [
                "GitHubApps",
            ],
            resources: [.process("Resources")]
        ),
    ]
)
