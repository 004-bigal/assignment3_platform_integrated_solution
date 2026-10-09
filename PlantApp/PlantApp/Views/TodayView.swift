//
//  TodayView.swift
//  PlantApp
//
//  Created by Alik Orgun on 8/10/2026.
//

import SwiftUI

struct TodayView: View {
    @State private var viewModel = TodayViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.plants.isEmpty {
                    Text("All of the plants are watered 🌿")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.plants) { plant in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(plant.plantName).font(.headline)
                                Text(plant.plantLocation)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Water") {
                                Task { await viewModel.water(plant) }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red).font(.caption)
                }
            }
            .navigationTitle("Needs Water")
            .task { await viewModel.load() }
            .refreshable { await viewModel.load() }
        }
    }
}
