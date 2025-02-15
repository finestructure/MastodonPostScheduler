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

        mutating func run() {
            print("list posts")
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

