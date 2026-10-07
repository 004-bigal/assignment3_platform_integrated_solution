//
//  WateringLogModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

struct WateringLog: Identifiable, Equatable {
    let id: UUID
    let plantID: UUID
    let wateredAt: Date

    init(id: UUID = UUID(), plantID: UUID, wateredAt: Date = .now) {
        self.id = id
        self.plantID = plantID
        self.wateredAt = wateredAt
    }
}
