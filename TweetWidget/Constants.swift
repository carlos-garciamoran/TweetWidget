//
//  Constants.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/6/23.
//

import Foundation

enum Constants {
    private static let SupabaseProjectId: String = "huymwhrrcvsbaefljxpo"
//    private static let SupabaseProjectId: String = ProcessInfo.processInfo.environment["SUPABASE_PROJECT_ID"]!
    static let SupabaseURL = URL(string: "https://\(SupabaseProjectId).supabase.co")!
    static let SupabaseFunctionsURL = URL(string: "https://\(SupabaseProjectId).functions.supabase.co")!
    static let SupabaseKey: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh1eW13aHJyY3ZzYmFlZmxqeHBvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzMyNjU1MjUsImV4cCI6MTk4ODg0MTUyNX0.9mRH4bNvEfXIh69O5bC0xItz22nPwRO793xdUhYXmck"
    //    static let SupabaseKey: String = ProcessInfo.processInfo.environment["SUPABASE_KEY"]!
}
