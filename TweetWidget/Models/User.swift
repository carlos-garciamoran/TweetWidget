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

// TODO: add parameter id ...
//          1. user stores username
//          2. get id from Supabase
//          3. store in local storage
struct UserDetail {
    let id: String          // Twitter id (12)
    let name: String        // Twitter username (@jack)
    let profilePicURL: String  // May want to turn it into image stored on device

    static let availableUsernames = [
        UserDetail(id: "12", name: "naval", profilePicURL: "🧘‍♂️"),
        UserDetail(id: "745273", name: "jack", profilePicURL: "☯️"),
        UserDetail(id: "44196397", name: "elonmusk", profilePicURL: "🚀"),
    ]

    static let availableUsers = [
        UserDetail(id: "12", name: "naval", profilePicURL: "🧘‍♂️"),
        UserDetail(id: "745273", name: "jack", profilePicURL: "☯️"),
        UserDetail(id: "44196397", name: "elonmusk", profilePicURL: "🚀"),
    ]
}
