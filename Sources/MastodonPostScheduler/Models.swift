import Foundation


enum Error: Swift.Error, CustomStringConvertible {
    case invalidDate(String)
    case invalidURL(String)
    case missingKey(String, expectedFormat: String)

    var description: String {
        switch self {
            case .invalidDate(let string):
                "Invalid date: '\(string)'. Expected format: '\(Post.dateFormat)'."
            case .invalidURL(let url):
                "Invalid URL: '\(url)'. Expected format: 'https://example.com'."
            case let .missingKey(key, expectedFormat: format):
                "Missing key: '\(key)'. Expected format: '\(format)'."
        }
    }
}


struct Post {
    var text: String
    var scheduledAt: Date
    var instance: URL
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

        do {
            let url = try container.decode(URL.self, forKey: Post.CodingKeys.instance)
            if url.scheme == nil {
                let urlString = "https://" + url.absoluteString
                guard let newURL = URL(string: urlString) else {
                    throw Error.invalidURL(urlString)
                }
                self.instance = newURL
            } else {
                self.instance = url
            }
        } catch DecodingError.keyNotFound {
            throw Error.missingKey(Post.CodingKeys.instance.stringValue,
                                   expectedFormat: "https://example.com")
        }

        self.language = try container.decodeIfPresent(String.self, forKey: Post.CodingKeys.language)
    }
}
