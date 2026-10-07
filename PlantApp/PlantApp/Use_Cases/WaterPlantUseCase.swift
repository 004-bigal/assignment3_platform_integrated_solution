//
//  WaterPlantUseCase.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation
import WidgetKit

// This code records that a plant has been watered today
// It enforces the business rule that a plant cannot be watered
// more than once in the same calendar day
struct WaterPlantUseCase {
    let repository: PlantRepo

    func execute(plantID: UUID) async throws {
        guard let plant = try await repository.fetchPlant(id: plantID) else {
            throw ErrorPlant.thePlantNotFound
        }

        if let last = plant.lastWatered,
           Calendar.current.isDateInToday(last) {
            throw ErrorPlant.alreadyWateredToday(plantName: plant.plantName)
        }

        try await repository.recordWatering(plantID: plantID, at: .now)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
