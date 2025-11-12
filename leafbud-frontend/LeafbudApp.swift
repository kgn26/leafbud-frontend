//
//  leafbud_frontendApp.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/5/25.
//

import SwiftUI
import SwiftData

@main
struct LeafbudApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [PlantLocal.self])
        .environmentObject(PlantInstViewModel.shared)
        .environmentObject(AuthViewModel.shared)
    }
}
