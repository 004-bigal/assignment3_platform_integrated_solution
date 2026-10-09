//
//  SettingsView.swift
//  PlantApp
//
//  Created by Alik Orgun on 9/10/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Notifications") {
                    Toggle("Daily water reminder", isOn: $notificationsEnabled)
                }
                Section("About") {
                    Text("PlantApp, helping plant sitters to keep every plant alive")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
