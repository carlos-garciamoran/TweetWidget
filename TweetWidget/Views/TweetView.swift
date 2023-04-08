//
//  TweetView.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/9/23.
//

import SwiftUI

/// Shows username and text.
struct SmallWidgetView: View {
    let tweet: Tweet

    var body: some View {
        Text("@" + tweet.username)
            .font(.system(size: 14))
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 1)
        
        Text(tweet.text)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Shows username and text, plus metrics.
struct MediumWidgetView: View {
    let tweet: Tweet

    var body: some View {
        SmallWidgetView(tweet: tweet)

        //  TODO: abbreviate numbers (do on backend?)
        HStack {
            HStack {
                Image(systemName: "arrowshape.turn.up.left")
                    .imageScale(.medium)
                    .foregroundColor(Color.gray)
                Text(String(tweet.replyCount))
                    .foregroundColor(Color.white)
            }.frame(maxWidth: .infinity)
            
            HStack {
                Image(systemName: "repeat")
                    .imageScale(.medium)
                    .foregroundColor(Color.cyan)
                Text(String(tweet.retweetCount))
                    .foregroundColor(Color.white)
            }.frame(maxWidth: .infinity)

            HStack {
                Image(systemName: "heart")
                    .font(.system(size: 16))
                    .imageScale(.medium)
                    .foregroundColor(Color.red)
                Text(String(tweet.likeCount))
                    .foregroundColor(Color.white)
            }.frame(maxWidth: .infinity)
        }
        .font(.system(size: 15))
        .padding(.top, 7)
    }
}

struct UnsupportedWidgetView: View {
    var body: some View {
        Text("Unsupported view. Ping us if you need it!")
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
        TweetView(tweet: Tweet.sampleData)
    }
}
