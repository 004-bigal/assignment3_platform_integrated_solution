//
//  PersistenceController.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import CoreData
import Foundation

// this file holds the data core container
class PersistenceController {
    static let shared = PersistenceController()
    static let appGroupID = "group.com.alikorgun.plant2026"

    let container: NSPersistentContainer

    // this code creates the core data stack
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PlantApp")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        } else if let groupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Self.appGroupID) {
            let storeURL = groupURL.appendingPathComponent("PlantApp.sqlite")
            container.persistentStoreDescriptions.first?.url = storeURL
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data failed: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // converts core data entity plant into a domain plant level entity
    func plant(from entity: PlantEntity) -> PlantModel {
        PlantModel(
            id: entity.id ?? UUID(),
            name: entity.plantName ?? "",
            location: entity.plantLocation ?? "",
            wateringIntervalDays: Int(entity.wateringInterval),
            lastWatered: entity.lastWatered
        )
    }

    // converts a core data WateringLogEntity into a domain level entity
    func wateringLog(from entity: WateringLogEntity) -> WateringLogModel? {
        guard let plantID = entity.plant?.id,
              let wateredAt = entity.wateredAt,
              let id = entity.id else { return nil }
        return WateringLogModel(id: id, plantID: plantID, wateredAt: wateredAt)
    }
}
