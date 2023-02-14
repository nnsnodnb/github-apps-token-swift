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
        .package(url: "https://github.com/ishkawa/APIKit.git", .upToNextMajor(from: "5.4.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", .upToNextMajor(from: "0.10.0")),
    ],
    targets: [
        .executableTarget(
            name: "GitHubAppsToken",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "GitHubAppsAPI",
            ]
        ),
        .target(
            name: "GitHubAppsAPI",
            dependencies: [
                .product(name: "APIKit", package: "APIKit"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .testTarget(
            name: "GitHubAppsTokenTests",
            dependencies: ["GitHubAppsToken"]
        ),
    ]
)
