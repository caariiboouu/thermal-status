//
//  Thermal_StatusBundle.swift
//  Thermal Status
//
//  Created by joel on 8/19/24.
//

import WidgetKit
import SwiftUI

@main
struct Thermal_StatusBundle: WidgetBundle {
    var body: some Widget {
        Thermal_Status()
        Thermal_StatusLiveActivity()
    }
}
