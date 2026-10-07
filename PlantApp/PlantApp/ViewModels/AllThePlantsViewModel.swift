//
//  AllThePlantsViewModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

// This is the viewmodel that deals with the AllPlantsView

import Foundation
import Observation

@Observable
class AllThePlantsViewModel {
    let repository: PlantRepo

    var plants: [PlantModel] = []
    var errorMessage: String?

    // initialiser
    init(repository: PlantRepo = CoreRepo()) {
        self.repository = repository
    }

    // loads the list of plants
    func load() async {
        do {
            plants = try await repository.fetchAllPlants()
            errorMessage = nil
        } catch {
            errorMessage = "Couldn't load your plants."
        }
    }
}
