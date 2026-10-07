//
//  PlantModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

struct Plant: Identifiable, Equatable {
    let id: UUID
    var plantName: String
    var plantLocation: String
    var wateringInterval: Int
    var lastWatered: Date?

    init(
        id: UUID = UUID(),
        name: String,
        location: String,
        wateringIntervalDays: Int,
        lastWatered: Date? = nil
    ) {
        self.id = id
        self.plantName = name
        self.plantLocation = location
        self.wateringInterval = wateringIntervalDays
        self.lastWatered = lastWatered
    }

    var needsWater: Bool {
        guard let last = lastWatered else { return true }
        let days = Calendar.current.dateComponents(
            [.day], from: last, to: Date()
        ).day ?? 0
        return days >= wateringInterval
    }
}
