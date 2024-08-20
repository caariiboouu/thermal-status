import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var thermalMonitor: ThermalMonitor
    
    init() {
        if #available(iOS 17, *) {
            _thermalMonitor = StateObject(wrappedValue: ThermalMonitor(modelContext: modelContext))
        } else {
            _thermalMonitor = StateObject(wrappedValue: ThermalMonitor(modelContext: nil))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current Thermal State")
                    .font(.title)
                Text(thermalStateDescription)
                    .font(.headline)
                    .padding()
                
                if #available(iOS 17, *) {
                    NavigationLink(destination: ThermalHistoryView()) {
                        Text("View History")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text("History view not available")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Thermal Monitor")
        }
    }
    
    var thermalStateDescription: String {
        switch thermalMonitor.thermalState {
        case .nominal: return "Nominal"
        case .fair: return "Fair"
        case .serious: return "Serious"
        case .critical: return "Critical"
        @unknown default: return "Unknown"
        }
    }
}
