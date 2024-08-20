//
//  Thermal_StatusLiveActivity.swift
//  Thermal Status
//
//  Created by joel on 8/19/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Thermal_StatusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Thermal_StatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Thermal_StatusAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Thermal_StatusAttributes {
    fileprivate static var preview: Thermal_StatusAttributes {
        Thermal_StatusAttributes(name: "World")
    }
}

extension Thermal_StatusAttributes.ContentState {
    fileprivate static var smiley: Thermal_StatusAttributes.ContentState {
        Thermal_StatusAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Thermal_StatusAttributes.ContentState {
         Thermal_StatusAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Thermal_StatusAttributes.preview) {
   Thermal_StatusLiveActivity()
} contentStates: {
    Thermal_StatusAttributes.ContentState.smiley
    Thermal_StatusAttributes.ContentState.starEyes
}
