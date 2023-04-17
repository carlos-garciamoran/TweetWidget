//
//  User.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/10/23.
//

import Foundation

let userDefaults = UserDefaults.init(suiteName: "group.com.cgmor.TweetWidget")!

struct User: Codable {
    let id: String?
    let username: String?
}

extension User {
    static let sampleData = User(
        id: "12",
        username: "jack"
    )

    static func getUserFromStorage() -> User {
        if userDefaults.object(forKey: "user") == nil {
            return User.sampleData
        }

        do {
            let encodedUser = userDefaults.object(forKey: "user") as? Data
            let decodedUser = try JSONDecoder().decode(User.self, from: encodedUser!)

            return decodedUser
        } catch {
            return User.sampleData
        }
    }
}

struct UserDetail {
    let id: String
    let username: String
    let profilePicURL: String  // May want to make it an image object (stored on device)

    static let availableUsers = [
        UserDetail(id: "12", username: "jack", profilePicURL: "☯️"),
        UserDetail(id: "745273", username: "naval", profilePicURL: "🧘‍♂️"),
        UserDetail(id: "44196397", username: "elonmusk", profilePicURL: "🚀"),
    ]
}

extension UserDetail {
    static let sampleData = UserDetail(
        id: "12",
        username: "jack",
        profilePicURL: "☯️"
    )
}
