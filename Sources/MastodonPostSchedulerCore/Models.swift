import Foundation


public struct Time: Codable {
    public var hour: Int
    public var minutes: Int = 0
}

public struct Post: Codable {
    public var text: String
    public var time: Time
}
