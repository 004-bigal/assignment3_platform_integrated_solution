//
//  WateringLogModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

// this is the watering log model
// this stores a watering log for a plant
struct WateringLogModel: Identifiable, Equatable {
    let id: UUID
    let plantID: UUID
    let wateredAt: Date

    // initialiser
    init(id: UUID = UUID(), plantID: UUID, wateredAt: Date = .now) {
        self.id = id
        self.plantID = plantID
        self.wateredAt = wateredAt
    }
}
