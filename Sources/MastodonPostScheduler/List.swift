import Foundation

import ArgumentParser
import TootSDK


extension MastodonPostScheduler {
    struct List: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "List scheduled posts.")

        @OptionGroup var options: Options

        mutating func run() async throws {
            print("Listing scheduled posts on \(options.instance) ...")
            try await MastodonPostScheduler.listPosts(instance: options.instance, token: options.token)
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
