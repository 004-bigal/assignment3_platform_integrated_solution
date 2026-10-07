//
//  AddPlantUseCase.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation
import WidgetKit

// This code adds a new plant to the collection
// It validates that the name is not empty and that the interval is at least one day
struct AddPlantUseCase {
    let repository: PlantRepo

    func execute(name: String, location: String, intervalDays: Int) async throws {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            throw ErrorPlant.emptyPlantName
        }
        guard intervalDays >= 1 else {
            throw ErrorPlant.invalidWateringInterval
        }

        let plant = PlantModel(
            name: trimmedName,
            location: location.trimmingCharacters(in: .whitespaces),
            wateringIntervalDays: intervalDays
        )
        try await repository.addPlant(plant)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
