//
//  CoreRepo.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import CoreData
import Foundation

class CoreRepo: PlantRepo {
    let persistence: PersistenceController

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }

    var context: NSManagedObjectContext {
        persistence.container.viewContext
    }

    func fetchAllPlants() async throws -> [PlantModel] {
        let request = PlantEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "plantName", ascending: true)]
        let entities = try context.fetch(request)
        return entities.map { persistence.plant(from: $0) }
    }

    func fetchPlant(id: UUID) async throws -> PlantModel? {
        let request = PlantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        guard let entity = try context.fetch(request).first else { return nil }
        return persistence.plant(from: entity)
    }

    func fetchPlantsNeedingWater() async throws -> [PlantModel] {
        let request = PlantEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "plantName", ascending: true)]

        let startOfToday = Calendar.current.startOfDay(for: Date())
        request.predicate = NSPredicate(
            format: "lastWatered == nil OR lastWatered < %@",
            startOfToday as NSDate
        )

        let candidates = try context.fetch(request)
        return candidates
            .map { persistence.plant(from: $0) }
            .filter { $0.needsWater }
    }

    func addPlant(_ plant: PlantModel) async throws {
        let entity = PlantEntity(context: context)
        entity.id = plant.id
        entity.plantName = plant.plantName
        entity.plantLocation = plant.plantLocation
        entity.wateringInterval = Int16(plant.wateringInterval)
        entity.lastWatered = plant.lastWatered
        try save()
    }

    func recordWatering(plantID: UUID, at date: Date) async throws {
        let request = PlantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", plantID as CVarArg)
        request.fetchLimit = 1
        guard let plantEntity = try context.fetch(request).first else {
            throw ErrorPlant.thePlantNotFound
        }

        plantEntity.lastWatered = date

        let log = WateringLogEntity(context: context)
        log.id = UUID()
        log.wateredAt = date
        log.plant = plantEntity

        try save()
    }

    func deletePlant(id: UUID) async throws {
        let request = PlantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        guard let entity = try context.fetch(request).first else {
            throw ErrorPlant.thePlantNotFound
        }
        context.delete(entity)
        try save()
    }

    private func save() throws {
        do {
            try context.save()
        } catch {
            throw ErrorPlant.saveFailed
        }
    }
}
