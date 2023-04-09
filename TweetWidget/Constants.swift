//
//  Constants.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/6/23.
//

import Foundation

enum Constants {
    static let SupabaseURL = URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"]!)!
    static let SupabaseKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"]!
}
