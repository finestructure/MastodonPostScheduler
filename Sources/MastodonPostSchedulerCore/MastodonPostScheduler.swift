import ArgumentParser


public struct MastodonPostScheduler: ParsableCommand {
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
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "List scheduled posts.")

        @OptionGroup var options: Options

        mutating func run() {
            print("list posts")
        }
    }
}

extension MastodonPostScheduler {
    struct Schedule: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Schedule a post.")

        @OptionGroup var options: Options
        @Option var input: String

        mutating func run() {
            print("schedule post")
        }
    }
}
