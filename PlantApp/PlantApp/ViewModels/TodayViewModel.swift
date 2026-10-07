//
//  TodayViewModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation
import Observation

// This ViewModel handles the "Needs Water" screen
// Loads plants needing water and handles the water action
@Observable
class TodayViewModel {
    let fetchUseCase: FetchThePlantsNeedingWaterUseCase
    let waterUseCase: WaterPlantUseCase

    var plants: [PlantModel] = []
    var errorMessage: String?

    // initialiser
    init(repository: PlantRepo = CoreRepo()) {
        self.fetchUseCase = FetchThePlantsNeedingWaterUseCase(repository: repository)
        self.waterUseCase = WaterPlantUseCase(repository: repository)
    }

    // fetches plants needing water
    func load() async {
        do {
            plants = try await fetchUseCase.execute()
            errorMessage = nil
        } catch let error as ErrorPlant {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Couldn't load your plants."
        }
    }

    // records a watering then reloads the list
    func water(_ plant: PlantModel) async {
        do {
            try await waterUseCase.execute(plantID: plant.id)
            await load()
        } catch let error as ErrorPlant {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Couldn't record that watering."
        }
    }
}
