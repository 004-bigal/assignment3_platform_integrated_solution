//
//  PlantAppApp.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import SwiftUI

@main
struct PlantAppApp: App {
    
    let persistence = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                TodayView()
                    .tabItem { Label("Today", systemImage: "drop") }
                AllThePlantsView()
                    .tabItem { Label("Plants", systemImage: "leaf") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
        }
    }
}
