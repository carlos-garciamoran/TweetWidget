//
//  TweetPreviewWidget.swift
//  TweetPreviewWidget
//
//  Created by Carlos García Morán on 4/14/23.
//

import WidgetKit
import SwiftUI

let darkGray = Color(red: 0.2, green: 0.2, blue: 0.3, opacity: 1.0)
let defaultUserDetail = UserDetail(id: "12", name: "jack", profilePicURL: "x")

struct TweetPreviewProvider: IntentTimelineProvider {
    let userDefaults = UserDefaults.init(suiteName: "group.com.cgmor.TweetWidget")!

    private var model = CoreViewModel()
    
    func placeholder(in context: Context) -> TweetPreviewEntry {
        TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData)
    }

    func getSnapshot(for configuration: SelectUserIntent, in context: Context, completion: @escaping (TweetPreviewEntry) -> ()) {
        let entry = TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData)
        completion(entry)
    }

    // TODO: get time interval and set nextUpdateDate accordingly.
    func getTimeline(for configuration: SelectUserIntent, in context: Context, completion: @escaping (Timeline<TweetPreviewEntry>) -> ()) {
        print("[i] TweetPreviewWidget@getTimeline")

        let currentDate = Date()

        // NOTE: we will need to change this is we are getting the latest tweet, or want another interval, etc.
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!

        // ! TODO: get id from username (write helper) OR [refactor backend and just pass username]!!
        let user = UserDetail(
            id: defaultUserDetail.id, // configuration.user?.id ?? defaultUserDetail.id
            name: configuration.user?.displayString ?? defaultUserDetail.name,
            profilePicURL: ""  // TODO: get from storage -> userDefaults
        )

        print("\tintent user: \(user.name)")

        Task {
            // NOTE: may want to create error tweet to inform user (through widget).
            let tweet: Tweet = await model.getRandomTweetFromUser(username: user.name, id: user.id).tweet ?? Tweet.sampleData

            let entry = TweetPreviewEntry(date: nextUpdateDate, user: user, tweet: tweet)

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
            .padding([.leading, .trailing], 20)
            .widgetURL(URL(string: "tweetwidget://\(entry.tweet.username)/status/\(entry.tweet.id)"))
        )
    }
}

// TODO: add support for .systemLarge supportedFamily.
struct TweetPreviewWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "TweetPreviewWidget",
            intent: SelectUserIntent.self,
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
