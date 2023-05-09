//
//  TweetView.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/9/23.
//

import SwiftUI
import WidgetKit

/// Shows username and text.
struct SmallWidgetView: View {
    let tweet: Tweet

    var body: some View {
        VStack {
            Text("@" + tweet.username)
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)

            Text(tweet.text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.foregroundColor(Color.white)
    }
}

//  TODO: abbreviate metric numbers (e.g., 1.3k)
/// Shows username and text, plus metrics.
struct MediumWidgetView: View {
    let tweet: Tweet

    func formatTimestamp(_ rawTimestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: rawTimestamp) {
            dateFormatter.dateFormat = "MMMM d, yyyy"

            return dateFormatter.string(from: date)
        } else {
            return rawTimestamp
        }
    }

    var body: some View {
        /// Username, timestamp, and text.
        VStack (spacing: 5) {
            HStack {
                // TODO: add link to Twitter user.
                Text("@" + tweet.username)
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(formatTimestamp(tweet.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.8))
            }

            Text(tweet.text)
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            /// Replies, retweets, and likes.
            HStack {
                HStack (spacing: 5) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .imageScale(.medium)
                        .foregroundColor(Color(white: 0.7))
                    Text(String(tweet.replyCount))
                }.frame(maxWidth: .infinity)

                HStack (spacing: 5) {
                    Image(systemName: "repeat")
                        .imageScale(.medium)
                        .foregroundColor(Color.cyan)
                    Text(String(tweet.retweetCount))
                }.frame(maxWidth: .infinity)

                HStack (spacing: 5) {
                    Image(systemName: "heart")
                        .imageScale(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(Color.red)
                    Text(String(tweet.likeCount))
                }.frame(maxWidth: .infinity)
            }
                .font(.system(size: 15))
                .padding(.horizontal)
        }
            .foregroundColor(Color.white)
            .padding(.top, 8)
            .padding(.bottom, 8)
    }
}

struct UnsupportedWidgetView: View {
    var body: some View {
        Text("Unsupported view. Ping me @cgarciamoran to add it on the next release!")
    }
}

/// Wrapper view.
struct TweetView: View {
    let tweet: Tweet

    var body: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(colors: [.black, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    MediumWidgetView(tweet: tweet)
                }.padding()
            )
            .cornerRadius(25)
            .frame(height: 180)
        }
    }
}

struct TweetView_Previews: PreviewProvider {
    static var previews: some View {
        TweetPreviewWidgetEntryView(entry: TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        TweetPreviewWidgetEntryView(entry: TweetPreviewEntry(date: Date(), user: defaultUserDetail, tweet: Tweet.sampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
