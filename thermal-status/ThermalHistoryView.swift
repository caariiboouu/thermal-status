import SwiftUI
import Charts
import SwiftData

@available(iOS 17, *)
struct ThermalHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var records: [ThermalRecord]
    @State private var timeRange: TimeRange = .hourly
    
    enum TimeRange: String, CaseIterable {
        case hourly, daily, weekly, monthly, yearly
    }
    
    // Add a public initializer
    public init() {
        // The @Query property wrapper initializes itself,
        // so we don't need to do anything here.
    }
    
    var body: some View {
         VStack {
             Picker("Time Range", selection: $timeRange) {
                 ForEach(TimeRange.allCases, id: \.self) { range in
                     Text(range.rawValue.capitalized)
                 }
             }
             .pickerStyle(SegmentedPickerStyle())
             .padding()
             
             ThermalChart(records: filteredRecords)
             
             List(filteredRecords) { record in
                 VStack(alignment: .leading) {
                     Text("State: \(thermalStateString(for: record.state))")
                     Text("Charging: \(record.isCharging ? "Yes" : "No")")
                     Text("Battery: \(Int(record.batteryLevel * 100))%")
                     Text("Active Info: \(record.activeAppInfo)")
                     Text("Time: \(formatDate(record.timestamp))")
                 }
             }
         }
     }
    
    private var filteredRecords: [ThermalRecord] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch timeRange {
        case .hourly:
            startDate = calendar.date(byAdding: .hour, value: -1, to: now)!
        case .daily:
            startDate = calendar.date(byAdding: .day, value: -1, to: now)!
        case .weekly:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .monthly:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        case .yearly:
            startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        }
        
        return records.filter { $0.timestamp >= startDate }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    private func thermalStateString(for value: Int) -> String {
        switch value {
        case 0: return "Nominal"
        case 1: return "Fair"
        case 2: return "Serious"
        case 3: return "Critical"
        default: return "Unknown"
        }
    }
}

@available(iOS 17, *)
struct ThermalChart: View {
    var records: [ThermalRecord]
    
    var body: some View {
        Chart(records) { record in
            LineMark(
                x: .value("Time", record.timestamp),
                y: .value("State", record.state)
            )
        }
        .chartYScale(domain: 0...3)
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text(thermalStateString(for: intValue))
                    }
                }
            }
        }
        .frame(height: 300)
        .padding()
    }
    
    private func thermalStateString(for value: Int) -> String {
        switch value {
        case 0: return "Nominal"
        case 1: return "Fair"
        case 2: return "Serious"
        case 3: return "Critical"
        default: return "Unknown"
        }
    }
}
