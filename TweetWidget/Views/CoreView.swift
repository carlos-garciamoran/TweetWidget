//
//  CoreView.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/5/23.
//

import SwiftUI
import WidgetKit

let accent = Color(red: 0.3, green: 0.9, blue: 0.9, opacity: 1.0)
let lighterGray = Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1.0)

struct ErrorView: View {
    let error: String
    
    var body: some View {
        Text(error)
            .padding(.top, 2)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// TODO: create new view named MainView or OnboardingView
struct CoreView: View {
    var invalidChars: CharacterSet = CharacterSet.alphanumerics.inverted

    @FocusState private var isTextFieldFocused: Bool
    @ObservedObject private var textBindingManager = TextBindingManager()
    @StateObject private var model = CoreViewModel()
    @State public var userResp = UserResponse(id: nil, error: nil)
    @State private var storedUser: User = User.getUserFromStorage()

    init() {
        invalidChars.remove("_")
    }

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                // DESIGN: animate (bounce) emoji
                if storedUser.username == "" || storedUser.username == nil {
                    Text("Add your favorite Twitter user ")
                        .font(.system(size: 24, weight: .light))
                } else {
                    Text("📲 Add the widget to the home screen!")
                        .font(.system(size: 18, weight: .light))
                }
            }
            .padding(.leading, 38)
            
            // TODO: if storedUsername not null (i.e., tweet retrieved), hide input box, show add widget msg, and display "done" button
            HStack {
                Text("👉 ").font(.title2)   // TODO: animate!

                // TODO: make placeholder lighterGray
                TextField("naval, jack, ...", text: $textBindingManager.text)
                    .focused($isTextFieldFocused)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                userResp.error == nil
                                    ? accent
                                    : Color.red
                                , lineWidth: 2
                            )
                    )
                    .onAppear {
//                        isTextFieldFocused = true
                    }
                    .onTapGesture {
                        userResp.error = nil
                    }
                    .onChange(of: textBindingManager.text) { _ in
                        let sanitizedUsername = textBindingManager.text.trimmingCharacters(
                            in: invalidChars
                        )
                        textBindingManager.text = sanitizedUsername
                    }
                    .onSubmit {
                        let submittedUsername = textBindingManager.text.lowercased()

                        if submittedUsername == storedUser.username {
                            userResp.error = "You are already getting tweets from @\(storedUser.username!)"
                            return
                        }

                        if submittedUsername.count < 4 {
                            userResp.error = "Username too short"
                            return
                        }

                        // TODO: get Twitter *name* from helper -> refactor backend.
                        Task {
                            print("[*] Getting Twitter user id...")

                            userResp = await model.getUserId(username: submittedUsername)

                            // Store the new user in local storage if we got a user id.
                            if userResp.id != nil  {  // Success.
                                let user = User(id: userResp.id, username: submittedUsername)
                                let encodedUser = try! JSONEncoder().encode(user)

                                print("\t[*] Storing user as \(user)")

                                userDefaults.set(encodedUser, forKey: "user")

                                storedUser = user   // Update state.

                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        }
                    }
            }

            VStack {
                if userResp.error != nil {
                    ErrorView(error: userResp.error!)
                }
            }.frame(height: 1).padding(.top, 5)

            // TODO: #DESIGN push down to bottom.
            if storedUser.username != nil {
                VStack {
                    HStack(spacing: 0) {
                        Text("ℹ️")
                            .font(.system(size: 10, weight: .light, design: .monospaced))
                            .padding(.trailing, 4)
                        Text("You are getting tweets from ")

                        // TODO: open user profile on Twitter app.
                        Link(destination: URL(string: "https://twitter.com/" + storedUser.username!)!, label: {
                            Text("@" + storedUser.username!)
                                .bold()
                                .foregroundColor(.white)
                        })
                    }
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                }
            }
        }
    }
}

struct CoreView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
