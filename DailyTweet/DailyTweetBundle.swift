//
//  DailyTweetBundle.swift
//  DailyTweet
//
//  Created by Carlos García Morán on 2/9/23.
//

import WidgetKit
import SwiftUI

@main
struct DailyTweetBundle: WidgetBundle {
    var body: some Widget {
        DailyTweet()
        DailyTweetLiveActivity()
    }
}
