//
//  User.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/10/23.
//

import Foundation

struct User: Codable {
    let id: String?
    let username: String?
}

extension User {
    static let sampleData = User(
        id: "",
        username: ""
    )
}
