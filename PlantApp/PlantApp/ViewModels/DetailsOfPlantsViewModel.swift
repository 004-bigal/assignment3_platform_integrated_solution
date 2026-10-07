//
//  DetailsOfPlantsViewModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 8/10/2026.
//

import Foundation
import Observation

@Observable
class DetailsOfPlantsViewModel {
    let plant: PlantModel
    let waterUseCase: WaterPlantUseCase

    var message: String?
    var wasWatered = false

    init(plant: PlantModel, repository: PlantRepo = CoreRepo()) {
        self.plant = plant
        self.waterUseCase = WaterPlantUseCase(repository: repository)
    }

    func water() async {
        do {
            try await waterUseCase.execute(plantID: plant.id)
            message = "Watered ✓"
            wasWatered = true
        } catch let error as ErrorPlant {
            message = error.errorDescription
        } catch {
            message = "Couldn't record that watering."
        }
    }
}
