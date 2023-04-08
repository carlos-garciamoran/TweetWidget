//
//  User.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/6/23.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let username: String
    let created_at: String
}
