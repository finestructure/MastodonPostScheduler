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

    @Option(help: "Mastodon instance to connect to.")
    var instance: URL
}


extension URL: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        let url = URL(string: argument)
        guard let url else { return nil }
        if url.scheme == nil {
            let urlString = "https://" + url.absoluteString
            guard let newURL = URL(string: urlString) else { return nil }
            self = newURL
        } else {
            self = url
        }
    }
}
