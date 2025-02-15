import Foundation

import ArgumentParser
import TootSDK


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
