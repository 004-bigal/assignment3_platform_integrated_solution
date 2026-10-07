//
//  PlantModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

// this is the plant model, that represents a single plant
struct Plant: Identifiable, Equatable {
    // variables, including ID all the way to name, location and when it was last watered
    let id: UUID
    var plantName: String
    var plantLocation: String
    var wateringInterval: Int
    var lastWatered: Date?

    // initialiser for each variable
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

    // computed needsWater variable
    // answers whether the plant should be watered today or not
    var needsWater: Bool {
        guard let last = lastWatered else { return true }
        let days = Calendar.current.dateComponents(
            [.day], from: last, to: Date()
        ).day ?? 0
        return days >= wateringInterval
    }
}
