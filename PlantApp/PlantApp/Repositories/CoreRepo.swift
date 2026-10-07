//
//  CoreRepo.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import CoreData
import Foundation

// The core data backed implementation of the PlantRepo
// Only type in the app that touches the core APIs directly
class CoreRepo: PlantRepo {
    let persistence: PersistenceController
    // initialiser
    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }

    var context: NSManagedObjectContext {
        persistence.container.viewContext
    }
    
    // The 2 functions below are reads
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

    // This function returns plants that need watering today
    // It predicates filters at the database level and then the domain rule
    // (`needsWater`) handles per plant intervals
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

    // The 2 functions below are write functions
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

    // removes a plant from the database by its ID
    // throws if the plant does not exist
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

    // thin wrapper function, translates raw errors into domain error
    func save() throws {
        do {
            try context.save()
        } catch {
            throw ErrorPlant.saveFailed
        }
    }
}
