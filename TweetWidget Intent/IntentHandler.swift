//
//  IntentHandler.swift
//  TweetWidget Intent
//
//  Created by Carlos García Morán on 4/15/23.
//

import Intents

let defaultUserINO = UserINO(identifier: "naval", display: "naval")

class IntentHandler: INExtension, SelectUserIntentHandling {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.

        return self
    }

    /// For now, return an array containing the user stored in storage.
    func provideUserOptionsCollection(
        for intent: SelectUserIntent,
        with completion: @escaping (INObjectCollection<UserINO>?, Error?) -> Void
    ) {
        // NOTE: if no user is set, Jack Dorsey will be returned ;)
        let rawUser = User.getUserFromStorage()
        
        print("@secured -> ", rawUser)

        // Parse the User object properties into UserINO
        let user = UserINO(
            identifier: rawUser.id,
            display: rawUser.username!
        )

        // Create a collection with the array of users.
        let collection = INObjectCollection(items: [user])

        // Call the completion handler, passing the collection.
        completion(collection, nil)
    }

    // NOTE: currently unused.
    // TODO: implement displayImage
    private func getUsersFromStorage() -> [UserINO] {
        let userDefaults = UserDefaults.init(suiteName: "group.com.cgmor.TweetWidget")!

        /// User has not stored any user, return an empty array.
        if userDefaults.object(forKey: "users") == nil {
            return [defaultUserINO]
        }

        do {
            let encodedUsers = userDefaults.object(forKey: "users") as? Data
            let decodedUsers = try JSONDecoder().decode([User].self, from: encodedUsers!)

            let users: [UserINO] = decodedUsers.map { user in
                return UserINO(
                    identifier: user.id,
                    display: user.username ?? ""
                )
            }

            return users
        } catch {
            return [defaultUserINO]
        }
    }
}
