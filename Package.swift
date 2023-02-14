// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubAppsToken",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "github-apps-token",
            targets: ["GitHubAppsToken"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
    ],
    targets: [
        .executableTarget(
            name: "GitHubAppsToken",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "GitHubAppsTokenTests",
            dependencies: ["GitHubAppsToken"]
        ),
    ]
)
