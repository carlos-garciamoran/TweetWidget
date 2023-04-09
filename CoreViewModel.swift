//
//  CoreViewModel.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/10/23.
//

import Foundation

import Supabase

struct UserResponse: Decodable {
    let id: String?
    var error: String?
}
struct TweetResponse: Decodable {
    var tweet: Tweet?
    var error: String?
}

class TextBindingManager: ObservableObject {
    let characterLimit: Int = 15
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
}

class CoreViewModel: ObservableObject {
    let supabaseClient = SupabaseClient(supabaseURL: Constants.SupabaseURL, supabaseKey: Constants.SupabaseKey)

    func getUserId(username: String) async -> UserResponse {
        let query = supabaseClient.database
            .from("tracked_users")
            .select(columns: "id")
            .eq(column: "username", value: username)
            .single()

        // Get user id from DB.
        guard let cachedUser: UserResponse = try? await query.execute().value else {
            // No user found, hit Edge function to fetch user id.
            //guard let user: UserResponse = try? await edgeClient.invoke(
            guard let user: UserResponse = try? await supabaseClient.functions.invoke(
                functionName: "fetch-user-id",
                invokeOptions: .init(body: ["username": username])
            ) else {
                return UserResponse(id: nil, error: "Error fetching data. Check your connection!")
            }

            return user
        }

        return cachedUser
    }

    func getRandomTweetFromUser(username: String, id: String) async -> TweetResponse {
        // Fetch tweet through Edge Function.
        guard var tweetResp: TweetResponse = try? await supabaseClient.functions.invoke(
            functionName: "fetch-random-tweet-from-user",
            invokeOptions: .init(
                headers: [
                    "Authorization": "Bearer \(Constants.SupabaseKey)"
                ],
                body: [
                    "id": id,
                    "username": username
                ]
            )
        ) else {
            return TweetResponse(tweet: nil, error: "Error fetching data. Check your connection!")
        }

        if tweetResp.tweet == nil {
            tweetResp.tweet = Tweet.sampleData
            tweetResp.tweet?.text = "Could not fetch tweet, try again later."
        }

        return tweetResp
    }
}
