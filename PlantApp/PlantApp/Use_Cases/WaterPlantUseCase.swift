//
//  WaterPlantUseCase.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation
import WidgetKit

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
