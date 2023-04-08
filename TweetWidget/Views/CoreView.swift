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
let userDefaults = UserDefaults(suiteName: "group.com.cgmor.TweetWidget")!

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
    @State public var tweetResp = TweetResponse(tweet: Tweet.sampleData, error: nil)
    @State public var userResp = UserResponse(id: nil, error: nil)
    @State private var storedUsername: String = (userDefaults.string(forKey: "username") ?? "")  // TODO: get rid of var and read from userResp.

    init() {
        storedUsername = userDefaults.string(forKey: "username") ?? ""
        invalidChars.remove("_")
    }

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                // DESIGN: animate (bounce) emoji
                if storedUsername == "" {
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
                TextField("naval, paulg, ...", text: $textBindingManager.text)
                    .focused($isTextFieldFocused)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                userResp.error == nil && tweetResp.error == nil
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
                        tweetResp.error = nil
                    }
                    .onChange(of: textBindingManager.text) { _ in
                        let sanitizedUsername = textBindingManager.text.trimmingCharacters(
                            in: invalidChars
                        )
                        textBindingManager.text = sanitizedUsername
                    }
                    .onSubmit {
                        let submittedUsername = textBindingManager.text.lowercased()
                        
                        if submittedUsername == storedUsername {
                            userResp.error = "You are already getting tweets from @\(storedUsername)"
                            return
                        }
                        
                        if submittedUsername.count < 4 {
                            userResp.error = "Username too short"
                            return
                        }

                        // OPTIMIZE: extract into model method.
                        Task {
                            userResp = await model.getUserId(username: submittedUsername)
                            
                            if userResp.id != nil  {  // Success.
                                tweetResp = await model.getRandomTweetFromUser(username: submittedUsername, id: userResp.id!)
                                
                                if tweetResp.error == nil {
                                    // NOTE: could refactor to get encoded user.
                                    let user = User(id: userResp.id!, username: submittedUsername)
                                    let userData = try! JSONEncoder().encode(user)
                                    let tweetData = try! JSONEncoder().encode(tweetResp.tweet)
                                    
                                    // TODO: enhance error handling -> make sure we can decode tweet and only reload if so.
                                    
                                    userDefaults.set(tweetData, forKey: "tweet")
                                    userDefaults.set(userData, forKey: "user")
                                    userDefaults.set(submittedUsername, forKey: "username")
                                    
                                    storedUsername = submittedUsername  // Update state.
                                    
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            }
                        }
                    }
            }
            
            // TODO: move error state variable to CoreView and create Error component!
            // TODO: consolidate 2 views into one (create @State error var?) -> think React!
            VStack {
                if userResp.error != nil {
                    ErrorView(error: userResp.error!)
                }
                if tweetResp.error != nil {
                    ErrorView(error: tweetResp.error!)
                }
            }.frame(height: 1).padding(.top, 8)
            
            // TODO: #DESIGN push down to bottom.
            if !storedUsername.isEmpty {
                VStack {
                    HStack(spacing: 0) {
                        Text("ℹ️")
                            .font(.system(size: 10, weight: .light, design: .monospaced))
                            .padding(.trailing, 4)
                        Text("You are getting tweets from ")
                        // TODO: open on Twitter app.
                        Link(destination: URL(string: "https://twitter.com/" + storedUsername)!, label: {
                            Text("@" + storedUsername)
                                .bold()
                                .foregroundColor(.white)
                        })
                    }
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
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
