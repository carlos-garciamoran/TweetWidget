//
//  TweetWidgetApp.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/5/23.
//

import SwiftUI

@main
struct TweetWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                // TODO: track widget clicks (measure engagement!)
                .onOpenURL {url in
                    guard url.scheme == "tweetwidget" else { return }
                    openTweet(url: url)
                    print(url)
                }
        }
    }
}

func openTweet(url: URL) {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    let path = "\(components?.host! ?? "")\(components?.path ?? "")"

    guard let url = URL(string: "https://twitter.com/\(path)") else {
        print("Invalid URL")
        return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
