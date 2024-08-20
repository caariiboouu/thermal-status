import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.yourcompany.thermal-status")!

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), thermalState: "Unknown")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let thermalState = userDefaults.string(forKey: "currentThermalState") ?? "Unknown"
        let entry = SimpleEntry(date: Date(), thermalState: thermalState)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let thermalState = userDefaults.string(forKey: "currentThermalState") ?? "Unknown"
        let entry = SimpleEntry(date: Date(), thermalState: thermalState)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let thermalState: String
}

struct ThermalStateWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Thermal State")
                .font(.headline)
            Text(entry.thermalState)
                .font(.largeTitle)
        }
    }
}

struct ThermalStateWidget: Widget {
    let kind: String = "ThermalStateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ThermalStateWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Thermal State")
        .description("Displays the current thermal state of the device.")
        .supportedFamilies([.systemSmall])
    }
}
