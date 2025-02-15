import Foundation


enum Error: Swift.Error, CustomStringConvertible {
    case invalidDate(String)
    case missingKey(String, expectedFormat: String)

    var description: String {
        switch self {
            case .invalidDate(let string):
                "Invalid date: '\(string)'. Expected format: '\(Post.dateFormat)'."
            case let .missingKey(key, expectedFormat: format):
                "Missing key: '\(key)'. Expected format: '\(format)'."
        }
    }
}


struct Post {
    var text: String
    var scheduledAt: Date
    var language: String?

    static let dateFormat = "yyyy-MM-dd HH:mm"
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }

    init(contentsOf fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        self = try JSONDecoder().decode(Post.self, from: data)
    }
}


extension Post: Decodable {
    private enum CodingKeys: CodingKey {
        case text
        case scheduledAt
        case instance
        case language
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<Post.CodingKeys> = try decoder.container(keyedBy: Post.CodingKeys.self)
        
        self.text = try container.decode(String.self, forKey: Post.CodingKeys.text)

        do {
            let dateString = try container.decode(String.self, forKey: Post.CodingKeys.scheduledAt)
            guard let date = Self.dateFormatter.date(from: dateString) else {
                throw Error.invalidDate(dateString)
            }
            self.scheduledAt = date
        }

        self.language = try container.decodeIfPresent(String.self, forKey: Post.CodingKeys.language)
    }
}
