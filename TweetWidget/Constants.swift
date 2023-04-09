//
//  Constants.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/6/23.
//

import Foundation

enum Constants {
    // TODO: set up .xcconfig & remove values from version control.
    static let SupabaseURL = URL(string: "https://huymwhrrcvsbaefljxpo.supabase.co")!
    static let SupabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh1eW13aHJyY3ZzYmFlZmxqeHBvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzMyNjU1MjUsImV4cCI6MTk4ODg0MTUyNX0.9mRH4bNvEfXIh69O5bC0xItz22nPwRO793xdUhYXmck"
//    static let SupabaseURL = URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? "")!
//    static let SupabaseKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] ?? ""
}
