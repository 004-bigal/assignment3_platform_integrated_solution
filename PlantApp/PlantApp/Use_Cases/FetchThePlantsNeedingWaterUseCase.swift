//
//  FetchThePlantsNeedingWaterUseCase.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

// This code returns all plants that need watering today
// it is ordered alphabetically by name
struct FetchThePlantsNeedingWaterUseCase {
    let repository: PlantRepo

    func execute() async throws -> [PlantModel] {
        try await repository.fetchPlantsNeedingWater()
    }
}
