//
//  PersistenceController.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()
    static let appGroupID = "group.com.alikorgun.plantapp"

    let container: NSPersistentContainer

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

    func plant(from entity: PlantEntity) -> PlantModel {
        PlantModel(
            id: entity.id ?? UUID(),
            name: entity.plantName ?? "",
            location: entity.plantLocation ?? "",
            wateringIntervalDays: Int(entity.wateringInterval),
            lastWatered: entity.lastWatered
        )
    }

    func wateringLog(from entity: WateringLogEntity) -> WateringLogModel? {
        guard let plantID = entity.plant?.id,
              let wateredAt = entity.wateredAt,
              let id = entity.id else { return nil }
        return WateringLogModel(id: id, plantID: plantID, wateredAt: wateredAt)
    }
}
