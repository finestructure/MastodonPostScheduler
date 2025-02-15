import Foundation

import ArgumentParser
import TootSDK


extension MastodonPostScheduler {
    struct Delete: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Delete scheduled post.")

        @OptionGroup var options: Options
        @Option var id: String
        @Option var instance: URL

        mutating func run() async throws {
            print("Delete post '\(id)' posts on \(instance) ...")
            try await MastodonPostScheduler.delete(id: id, instance: instance, token: options.token)
        }
    }

    static func delete(id: String, instance: URL, token: String) async throws {
        print("Connecting...")
        let client = try await TootClient(connect: instance, accessToken: token)
        print("Connected.")
        try await client.deleteScheduledPost(id: id)
        print("Post '\(id)' deleted.")
    }
}
