import Foundation
import SwiftData

@Model
final class ThermalRecord {
    var timestamp: Date
    var state: Int
    var isCharging: Bool
    var batteryLevel: Float
    var activeAppInfo: String
    
    init(timestamp: Date, state: Int, isCharging: Bool, batteryLevel: Float, activeAppInfo: String) {
        self.timestamp = timestamp
        self.state = state
        self.isCharging = isCharging
        self.batteryLevel = batteryLevel
        self.activeAppInfo = activeAppInfo
    }
}
