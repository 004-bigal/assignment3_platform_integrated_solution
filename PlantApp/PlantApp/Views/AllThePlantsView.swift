//
//  AllThePlantsView.swift
//  PlantApp
//
//  Created by Alik Orgun on 8/10/2026.
//

import SwiftUI

struct AllThePlantsView: View {
    @State private var viewModel = AllThePlantsViewModel()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List(viewModel.plants) { plant in
                NavigationLink(plant.plantName) {
                    DetailsOfThePlantsView(plant: plant, onChanged: {
                        Task { await viewModel.load() }
                    })
                }
            }
            .navigationTitle("All Plants")
            .toolbar {
                Button("Add", systemImage: "plus") { showingAdd = true }
            }
            .sheet(isPresented: $showingAdd) {
                AddAPlantView(onSaved: { Task { await viewModel.load() } })
            }
            .task { await viewModel.load() }
        }
    }
}
