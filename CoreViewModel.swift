//
//  CoreViewModel.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/10/23.
//

import Foundation

import Functions
import PostgREST
import Supabase

struct UserResponse: Decodable {
    let id: String?
    var error: String?
}
struct TweetResponse: Decodable {
    let tweet: Tweet?
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
    let dbClient: PostgrestClient
    let edgeClient: FunctionsClient

    init() {
        dbClient = SupabaseClient(supabaseURL: Constants.SupabaseURL, supabaseKey: Constants.SupabaseKey).database
        edgeClient = FunctionsClient(
            url: Constants.SupabaseFunctionsURL,
            headers: [ "Authorization": "Bearer \(Constants.SupabaseKey)" ]
        )
    }

    func getUserId(username: String) async -> UserResponse {
        let query = dbClient
            .from("tracked_users")
            .select(columns: "id")
            .eq(column: "username", value: username)
            .single()

        // Get user id from DB.
        guard let cachedUser: UserResponse = try? await query.execute().value else {
            // No user found, hit Edge function to fetch user id.
            guard let user: UserResponse = try? await edgeClient.invoke(
                functionName: "fetch-user-id",
                invokeOptions: FunctionInvokeOptions(body: ["username": username])
            ) else {
                return UserResponse(id: nil, error: "Error fetching data. Check your connection!")
            }

            return user
        }

        return cachedUser
    }

    func getRandomTweetFromUser(username: String, id: String) async -> TweetResponse {
//        let query = dbClient
//            .from("daily_tweets")
//            .select(columns: "*")
//            .eq(column: "username", value: username)
//            .single()

        // Get daily tweet from DB.
        // guard let cachedTweet: TweetResponse = try? await query.execute().value else {
        // No tweet found, hit Edge function to fetch tweet.
        guard let tweet: TweetResponse = try? await edgeClient.invoke(
            functionName: "fetch-random-tweet-from-user",
            invokeOptions: FunctionInvokeOptions(body: ["id": id, "username": username])
        ) else {
            return TweetResponse(tweet: nil, error: "Error fetching data. Check your connection!")
        }

        return tweet
//         }
//        return cachedTweet
    }
}
