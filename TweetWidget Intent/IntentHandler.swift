//
//  IntentHandler.swift
//  TweetWidget Intent
//
//  Created by Carlos García Morán on 4/15/23.
//

import Intents

let defaultUserINO = UserINO(identifier: "naval", display: "naval")
let userDefaults = UserDefaults.init(suiteName: "group.com.cgmor.TweetWidget")!

class IntentHandler: INExtension, SelectUserIntentHandling {
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.

        return self
    }

    func provideUserOptionsCollection(
        for intent: SelectUserIntent,
        with completion: @escaping (INObjectCollection<UserINO>?, Error?) -> Void
    ) {
//          let users = getUsersFromStorage()
        let users: [UserINO] = UserDetail.availableUsers.map { user in
            print("NEW added \(user.name)")
            // TODO: implement displayImage
            return UserINO(
                identifier: user.name,
                display: user.name
                // display: "\(user.profilePicURL) - \(user.name)"
            )
        }

        print("[i] NEW users: ", users)

        // Create a collection with the array of users.
        let collection = INObjectCollection(items: users)

        // Call the completion handler, passing the collection.
        completion(collection, nil)
    }

//    private func getUsersFromStorage() -> [UserINO] {
//        /// User has not stored any user, return an empty array.
//        if userDefaults.object(forKey: "users") == nil {
//            print("no key set")
//            return [defaultUserINO]
//        }
//
//        do {
//            let encodedUsers = userDefaults.object(forKey: "users") as? Data
//            let decodedUsers = try JSONDecoder().decode([User].self, from: encodedUsers!)
//
//            let users: [UserINO] = decodedUsers.map { user in
//                return UserINO(
//                    identifier: user.id,
//                    display: user.username ?? ""
//                )
//            }
//
//            return users
//        } catch {
//            print("decoding error")
//            return [defaultUserINO]
//        }
//    }
}
