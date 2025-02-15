// swift-tools-version: 6.0


import PackageDescription

let package = Package(
    name: "MastodonPostScheduler",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "mastodon-post-scheduler",
                    targets: ["MastodonPostScheduler"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/TootSDK/TootSDK", from: "12.2.0")
    ],
    targets: [
        .executableTarget(
            name: "MastodonPostScheduler",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TootSDK", package: "TootSDK")
            ]
        )
    ]
)
