//
//  HomeView.swift
//  TweetWidget
//
//  Created by Carlos García Morán on 2/5/23.
//

import SwiftUI
import PostgREST
import UIKit

struct HomeView: View {
    // TODO: make global or something (accent color)
    let accent = Color(red: 0.3, green: 0.9, blue: 0.9, opacity: 1.0)
    let lightGray = Color(red: 0.8, green: 0.9, blue: 0.9, opacity: 1.0)

    // NOTE: this could be an onboarding screen (interactive tutorial)
    var body: some View {
        VStack {
            // TODO: add SVG illustration of 2-3 people saying hi
            VStack(alignment: .leading) {
                Text("Welcome to ")
                Text("TweetWidget 👋").foregroundColor(accent)
            }.font(.system(size: 42, weight: .light, design: .monospaced))

            Divider().frame(height: 4.0).overlay(accent)
            Spacer()

            CoreView()

            Spacer()
            Divider().frame(height: 1.33).overlay(lightGray)

            HStack (spacing: 0) {
                Text("💡").padding(.trailing, 1)
                Text("Built by ")
                Link(destination: URL(string: "https://twitter.com/cgarciamoran")!, label: {
                    Text("Carlos")
                        .underline()
                        .foregroundColor(Color(UIColor.label))
                        .fontWeight(.medium)
                })
            }.font(Font.footnote).padding(.top)
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
