//
//  ErrorPlant.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

enum ErrorPlant: LocalizedError, Equatable {
    case thePlantNotFound
    case alreadyWateredToday(plantName: String)
    case invalidWateringInterval
    case emptyPlantName
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .thePlantNotFound:
            return "This plant is no longer in your collection"
        case .alreadyWateredToday(let name):
            return "\(name) was already watered today. Check back tomorrow"
        case .invalidWateringInterval:
            return "Watering interval must be at least 1 day"
        case .emptyPlantName:
            return "Please give your plant a name"
        case .saveFailed:
            return "Couldn't save your change. Please try again"
        }
    }
}
