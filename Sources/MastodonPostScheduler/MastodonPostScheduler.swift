import Foundation

import ArgumentParser
import TootSDK


@main
public struct MastodonPostScheduler: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A utility for performing maths.",
        subcommands: [Delete.self, List.self, Schedule.self],
        defaultSubcommand: List.self
    )

    public init() { }
}


struct Options: ParsableArguments {
    @Option(help: "Mastodon access token.")
    var token: String
}
