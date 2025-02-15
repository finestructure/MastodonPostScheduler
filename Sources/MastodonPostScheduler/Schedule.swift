import Foundation

import ArgumentParser
import TootSDK


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
