//
//  FetchThePlantsNeedingWaterUseCase.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

struct FetchThePlantsNeedingWaterUseCase {
    let repository: PlantRepo

    func execute() async throws -> [PlantModel] {
        try await repository.fetchPlantsNeedingWater()
    }
}
