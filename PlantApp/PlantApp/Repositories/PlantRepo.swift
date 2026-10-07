//
//  PlantRepo.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

protocol PlantRepo {
    func fetchAllPlants() async throws -> [PlantModel]
    func fetchPlant(id: UUID) async throws -> PlantModel?
    func fetchPlantsNeedingWater() async throws -> [PlantModel]
    func addPlant(_ plant: PlantModel) async throws
    func recordWatering(plantID: UUID, at date: Date) async throws
    func deletePlant(id: UUID) async throws
}
