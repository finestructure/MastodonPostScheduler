// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MastodonPostScheduler",
    products: [
        .executable(name: "mastodon-post-scheduler",
                    targets: ["MastodonPostScheduler"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(name: "MastodonPostScheduler", dependencies: ["MastodonPostSchedulerCore"]),
        .target(name: "MastodonPostSchedulerCore", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ])
    ]
)
