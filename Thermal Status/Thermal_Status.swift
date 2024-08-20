//
//  Thermal_Status.swift
//  Thermal Status
//
//  Created by joel on 8/19/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), thermalState: .nominal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), thermalState: ProcessInfo.processInfo.thermalState)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), thermalState: ProcessInfo.processInfo.thermalState)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let thermalState: ProcessInfo.ThermalState
}

struct Thermal_StatusEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Thermal State:")
            Text(thermalStateDescription(for: entry.thermalState))
                .font(.headline)
        }
    }
    
    private func thermalStateDescription(for state: ProcessInfo.ThermalState) -> String {
        switch state {
        case .nominal: return "Nominal"
        case .fair: return "Fair"
        case .serious: return "Serious"
        case .critical: return "Critical"
        @unknown default: return "Unknown"
}
    }
}

struct Thermal_Status: Widget {
    let kind: String = "Thermal_Status"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Thermal_StatusEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemSmall) {
    Thermal_Status()
} timeline: {
    SimpleEntry(date: .now, thermalState: .nominal)
    SimpleEntry(date: .now, thermalState: .fair)
}
