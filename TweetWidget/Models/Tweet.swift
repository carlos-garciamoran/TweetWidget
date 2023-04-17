//
//  Tweet.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/5/23.
//

struct Tweet: Codable {
    let id: String
    var text: String
    let username: String
    let replyCount: Int
    let likeCount: Int
    let retweetCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case username
        case replyCount = "reply_count"
        case likeCount = "like_count"
        case retweetCount = "retweet_count"
    }
}

extension Tweet {
    static let sampleData = Tweet(
        id: "1640774004104372231",
        text: "This is how tweets will look!",
        username: "cgarciamoran",
        replyCount: 96,
        likeCount: 1337,
        retweetCount: 40
    )
}
