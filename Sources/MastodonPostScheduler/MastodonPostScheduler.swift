import Foundation

import ArgumentParser
import TootSDK


@main
public struct MastodonPostScheduler: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A utility for performing maths.",
        subcommands: [List.self, Schedule.self],
        defaultSubcommand: List.self
    )

    public init() { }
}


struct Options: ParsableArguments {
    @Option(help: "Mastodon access token.")
    var token: String
}


extension MastodonPostScheduler {
    struct List: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "List scheduled posts.")

        @OptionGroup var options: Options
        @Option var instance: URL

        mutating func run() async throws {
            print("Listing scheduled posts on \(instance) ...")
            try await MastodonPostScheduler.listPosts(instance: instance, token: options.token)
        }
    }

    static func listPosts(instance: URL, token: String) async throws {
        print("Connecting...")
        let client = try await TootClient(connect: instance, accessToken: token)
        print("Connected.")
        let page = try await client.getScheduledPosts()
        var firstResult = true
        for post in page.result
            .filter({ $0.scheduledAt != nil })
            .sorted(by: { $0.scheduledAt! < $1.scheduledAt! }) {
            defer { firstResult = false }
            if firstResult {
                print("scheduled at             ", "  |  ", "id")
                print("---------------------------------------")
            }
            print(post.scheduledAt!, "  |  ", post.id)
        }
    }

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


extension MastodonPostScheduler {
    struct Schedule: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Schedule a post.")

        @OptionGroup var options: Options
        @Option var input: String

        mutating func run() async throws {
            let post = try Post(contentsOf: URL(filePath: input))
            print("Scheduling post at \(post.scheduledAt) on \(post.instance) ...")
            let scheduledPost = try await MastodonPostScheduler.schedulePost(post, token: options.token)
            print("Post scheduled, id:", scheduledPost.id)
        }
    }

    static func schedulePost(_ post: Post, token: String) async throws -> ScheduledPost {
        print("Connecting ...")
        let client = try await TootClient(connect: post.instance, accessToken: token)
        print("Connected.")
        let params = ScheduledPostParams.init(
            text: post.text,
            visibility: .public,
            language: post.language ?? "en",
            scheduledAt: post.scheduledAt
        )
        return try await client.schedulePost(params)
    }
}

