import SwiftUI
import SwiftData

@main
struct ThermalMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17, *) {
                ContentView()
                    .modelContainer(for: ThermalRecord.self)
            } else {
                ContentView()
            }
        }
    }
}
