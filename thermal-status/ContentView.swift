import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var thermalMonitor: ThermalMonitor
    
    init() {
        if #available(iOS 17, *) {
            _thermalMonitor = State(initialValue: ThermalMonitor(modelContext: ModelContext(try! ModelContainer(for: ThermalRecord.self))))
        } else {
            _thermalMonitor = State(initialValue: ThermalMonitor(modelContext: nil))
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
                    NavigationLink {
                        ThermalHistoryView()
                    } label: {
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
