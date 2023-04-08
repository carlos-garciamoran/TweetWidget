//
//  DailyTweetWidgetBundle.swift
//  DailyTweetWidget
//
//  Created by Carlos García Morán on 2/9/23.
//

import WidgetKit
import SwiftUI

@main
struct DailyTweetWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyTweetWidget()

        if #available(iOSApplicationExtension 16.2, *) {
            DailyTweetWidgetLiveActivity()
        }
    }
}
