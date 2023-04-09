//
//  DailyTweetWidget.swift
//  DailyTweetWidget
//
//  Created by Carlos García Morán on 2/9/23.
//

import WidgetKit
import SwiftUI
import Intents

let darkGray = Color(red: 0.2, green: 0.2, blue: 0.3, opacity: 1.0)

struct Provider: IntentTimelineProvider {
    private var model = CoreViewModel()

    let userDefaults = UserDefaults.init(suiteName: "group.com.cgmor.TweetWidget")!

    /// Try getting the tweet from local storage, otherwise return the default one.
    func getTweetFromStorage() -> Tweet {
        if userDefaults.object(forKey: "tweet") == nil {
             return Tweet.sampleData
        }

        do {
            let encodedTweet = userDefaults.object(forKey: "tweet") as? Data
            let decodedTweet = try JSONDecoder().decode(Tweet.self, from: encodedTweet!)

            return decodedTweet
        } catch {
            return Tweet.sampleData
        }
    }

    func getUserFromStorage() -> User {
        if userDefaults.object(forKey: "user") == nil {
            return User.sampleData
        }

        do {
            let encodedUser = userDefaults.object(forKey: "user") as? Data
            let decodedUser = try JSONDecoder().decode(User.self, from: encodedUser!)

            return decodedUser
        } catch {
            return User.sampleData
        }
    }

    func placeholder(in context: Context) -> TweetEntry {
        TweetEntry(date: Date(), configuration: ConfigurationIntent(), tweet: Tweet.sampleData)
    }

    // BUG: snapshot caches stored tweet. Fix so that it grabs the latest.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TweetEntry) -> ()) {
        var finalTweet = Tweet.sampleData

        // OPTIMIZE: avoid pyramid of doom.
        if userDefaults.object(forKey: "tweet") != nil {
            if let encodedTweet = userDefaults.object(forKey: "tweet") as? Data {
                let decodedTweet = try? JSONDecoder().decode(Tweet.self, from: encodedTweet)
                if let tweet = decodedTweet {
                    finalTweet = tweet
                }
            }
        }

        completion(TweetEntry(date: Date(), configuration: configuration, tweet: finalTweet))
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()

        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!

        let user = getUserFromStorage()

        Task {
            // NOTE: may want to create error tweet to pass down error.
            let tweet: Tweet = await model.getRandomTweetFromUser(username: user.username!, id: user.id!).tweet ?? Tweet.sampleData

            let entry = TweetEntry(date: nextUpdateDate, configuration: configuration, tweet: tweet)

            let timeline = Timeline(entries: [entry], policy: .atEnd)

            completion(timeline)
        }
    }
}

struct TweetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let tweet: Tweet
}

struct DailyTweetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry

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

struct DailyTweetWidget: Widget {
    let kind: String = "DailyTweetWidget"

    // TODO: add support for .systemLarge supportedFamily.
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            DailyTweetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Tweet")
        .description("Displays daily tweet of your chosen user.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DailyTweetEntryViewSmall: View {
    @Environment(\.widgetFamily) var family: WidgetFamily

    var entry: Provider.Entry

    var body: some View {
        DailyTweetEntryView(
            entry: TweetEntry(date: Date(), configuration: ConfigurationIntent(), tweet: Tweet.sampleData)
        )
    }
}


//TODO: change name and use same view for DailyTweetEntry
struct DailyTweetWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyTweetEntryView(
            entry: TweetEntry(date: Date(), configuration: ConfigurationIntent(), tweet: Tweet.sampleData)
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        DailyTweetEntryView(
            entry: TweetEntry(date: Date(), configuration: ConfigurationIntent(), tweet: Tweet.sampleData)
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
