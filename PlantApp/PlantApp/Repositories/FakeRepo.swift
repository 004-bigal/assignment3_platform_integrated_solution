//
//  FakeRepo.swift
//  PlantApp
//
//  Created by Alik Orgun on 9/10/2026.
//

import Foundation

class FakeRepo: PlantRepo {
    var plants: [PlantModel] = []
    var waterings: [WateringLogModel] = []
    var shouldThrow: ErrorPlant?

    func fetchAllPlants() async throws -> [PlantModel] {
        if let error = shouldThrow { throw error }
        return plants
    }

    func fetchPlant(id: UUID) async throws -> PlantModel? {
        if let error = shouldThrow { throw error }
        return plants.first { $0.id == id }
    }

    func fetchPlantsNeedingWater() async throws -> [PlantModel] {
        if let error = shouldThrow { throw error }
        return plants.filter { $0.needsWater }
    }

    func addPlant(_ plant: PlantModel) async throws {
        if let error = shouldThrow { throw error }
        plants.append(plant)
    }

    func recordWatering(plantID: UUID, at date: Date) async throws {
        if let error = shouldThrow { throw error }
        guard let idx = plants.firstIndex(where: { $0.id == plantID }) else {
            throw ErrorPlant.thePlantNotFound
        }
        plants[idx].lastWatered = date
        waterings.append(WateringLogModel(plantID: plantID, wateredAt: date))
    }

    func deletePlant(id: UUID) async throws {
        if let error = shouldThrow { throw error }
        plants.removeAll { $0.id == id }
    }
}
