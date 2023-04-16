//
//  TweetPreviewWidgetBundle.swift
//  TweetPreviewWidget
//
//  Created by Carlos García Morán on 4/14/23.
//

import WidgetKit
import SwiftUI

@main
struct TweetPreviewWidgetBundle: WidgetBundle {
    var body: some Widget {
        TweetPreviewWidget()
        
        if #available(iOSApplicationExtension 16.2, *) {
            TweetPreviewWidgetLiveActivity()
        }
    }
}
