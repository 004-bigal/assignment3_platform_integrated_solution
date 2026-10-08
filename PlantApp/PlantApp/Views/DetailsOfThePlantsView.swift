//
//  DetailsOfThePlantsView.swift
//  PlantApp
//
//  Created by Alik Orgun on 8/10/2026.
//

import SwiftUI

struct DetailsOfThePlantsView: View {
    @State private var viewModel: DetailsOfPlantsViewModel
    let onChanged: () -> Void

    init(plant: PlantModel, onChanged: @escaping () -> Void) {
        _viewModel = State(initialValue: DetailsOfPlantsViewModel(plant: plant))
        self.onChanged = onChanged
    }

    var body: some View {
        Form {
            Section("Plant") {
                LabeledContent("Name", value: viewModel.plant.plantName)
                LabeledContent("Location", value: viewModel.plant.plantLocation)
                LabeledContent("Water every",
                               value: "\(viewModel.plant.wateringInterval) days")
            }
            if let last = viewModel.plant.lastWatered {
                Section("Last watered") {
                    Text(last.formatted(date: .abbreviated, time: .shortened))
                }
            }
            if let message = viewModel.message {
                Text(message)
                    .foregroundStyle(viewModel.wasWatered ? .green : .red)
            }
            Button("Water Now") {
                Task {
                    await viewModel.water()
                    onChanged()
                }
            }
        }
        .navigationTitle(viewModel.plant.plantName)
    }
}
