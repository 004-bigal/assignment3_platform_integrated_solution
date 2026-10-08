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

                }
            }
            .navigationTitle("All Plants")
            .toolbar {
                Button("Add", systemImage: "plus") { showingAdd = true }
            }
            .sheet(isPresented: $showingAdd) {

            }
            .task { await viewModel.load() }
        }
    }
}

#Preview {
    AllThePlantsView()
}
