//
//  TweetPreviewWidget.swift
//  TweetPreviewWidget
//
//  Created by Carlos García Morán on 4/14/23.
//

import WidgetKit
import SwiftUI

let darkGray = Color(red: 0.2, green: 0.2, blue: 0.3, opacity: 1.0)
let defaultUserDetail = UserDetail.sampleData

struct TweetPreviewProvider: TimelineProvider {
    private var model = CoreViewModel()
    
    func placeholder(in context: Context) -> TweetPreviewEntry {
        TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData)
    }

    func getSnapshot(in context: Context, completion: @escaping (TweetPreviewEntry) -> ()) {
        let entry = TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData)
        completion(entry)
    }

    // TODO: get time interval and set nextUpdateDate accordingly.
    func getTimeline(in context: Context, completion: @escaping (Timeline<TweetPreviewEntry>) -> ()) {
        print("-> TweetPreviewWidget@getTimeline")

        let currentDate = Date()
        
        // NOTE: this will change when we user wants another interval (through intent), or most recent tweet.
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        
        // Get the user id —required to fetch the tweet.
        // NOTE: in the future —when handling multiple users—, we will get the *user id* from the passed username
        //       (SelectUserIntent) by searching on the `users`, userDefaults key, which will contain an array of
        //       the Twitter users stored locally (as selected by the user in the app).
        let user = User.getUserFromStorage()
        
        // >>> TODO: solve bug where sampleData is always returned (12, jack)

        print("\t[+] Got user from storage! username=\(user.username!)")

        let userDetail = UserDetail(
            id: user.id!,
            username: user.username!,
            profilePicURL: ""  // TODO: get from storage -> userDefaults
        )

        Task {
            // NOTE: may want to create error tweet to inform user (through widget).
            let tweet: Tweet = await model.getRandomTweetFromUser(username: user.username!, id: user.id!).tweet ?? Tweet.sampleData

            print("[+] Got tweet", tweet)

            let entry = TweetPreviewEntry(date: nextUpdateDate, user: userDetail, tweet: tweet)

            let timeline = Timeline(entries: [entry], policy: .atEnd)

            completion(timeline)
        }
    }
}

struct TweetPreviewEntry: TimelineEntry {
    let date: Date
    let user: UserDetail
    let tweet: Tweet
}

struct TweetPreviewWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: TweetPreviewProvider.Entry

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [darkGray, .black]), startPoint: .top, endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.vertical)
        .overlay(
            VStack {
                switch family {
                case .accessoryCircular, .accessoryRectangular, .accessoryInline:
                    UnsupportedWidgetView()
                case .systemSmall:
                    SmallWidgetView(tweet: entry.tweet)
                case .systemMedium, .systemLarge, .systemExtraLarge:
                    MediumWidgetView(tweet: entry.tweet)
                @unknown default:
                    UnsupportedWidgetView()
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding([.leading, .trailing], 17)
            .widgetURL(URL(string: "tweetwidget://\(entry.tweet.username)/status/\(entry.tweet.id)"))
        )
    }
}

// TODO: add support for .systemLarge supportedFamily.
struct TweetPreviewWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "TweetPreviewWidget",
            // intent: SelectUserIntent.self,
            provider: TweetPreviewProvider()
        ) { entry in
            TweetPreviewWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tweet")
        .description("Displays a tweet from a given user.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TweetPreviewWidget_Previews: PreviewProvider {
    static var previews: some View {
        TweetPreviewWidgetEntryView(entry: TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        TweetPreviewWidgetEntryView(entry: TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
