import Foundation
import Combine
import SwiftData
import UIKit

@Observable
class ThermalMonitor {
    var thermalState: ProcessInfo.ThermalState = .nominal
    var isCharging: Bool = false
    var batteryLevel: Float = 0.0
    
    private var observer: NSObjectProtocol?
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext?) {
        self.modelContext = modelContext
        updateThermalState()
        updateBatteryInfo()
        setupObservers()
    }
    
    private func setupObservers() {
        observer = NotificationCenter.default.addObserver(
            forName: ProcessInfo.thermalStateDidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateThermalState()
            }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    private func updateThermalState() {
        let newState = ProcessInfo.processInfo.thermalState
        thermalState = newState
        saveThermalState(newState)
    }
    
    private func updateBatteryInfo() {
        isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
        batteryLevel = UIDevice.current.batteryLevel
    }
    
    @objc private func batteryStateDidChange(_ notification: Notification) {
        updateBatteryInfo()
    }
    
    @objc private func batteryLevelDidChange(_ notification: Notification) {
        updateBatteryInfo()
    }
    
    private func saveThermalState(_ state: ProcessInfo.ThermalState) {
        guard let modelContext = modelContext else { return }
        
        let thermalRecord = ThermalRecord(
            timestamp: Date(),
            state: state.rawValue,
            isCharging: isCharging,
            batteryLevel: batteryLevel,
            activeAppInfo: getActiveAppInfo()
        )
        
        modelContext.insert(thermalRecord)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save thermal state: \(error)")
        }
    }
    
    private func getActiveAppInfo() -> String {
        let workspaceInfo = ProcessInfo.processInfo.activeProcessorCount
        let memoryUsage = Float(ProcessInfo.processInfo.physicalMemory) / (1024.0 * 1024.0 * 1024.0) // in GB
        return "Processors: \(workspaceInfo), Memory: \(String(format: "%.2f", memoryUsage)) GB"
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
}
