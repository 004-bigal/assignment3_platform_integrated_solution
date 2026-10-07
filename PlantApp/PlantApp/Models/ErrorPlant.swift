//
//  ErrorPlant.swift
//  PlantApp
//
//  Created by Alik Orgun on 7/10/2026.
//

import Foundation

// this is the file that handles errors for plant collection and watering
enum ErrorPlant: LocalizedError, Equatable {
    // error cases
    case thePlantNotFound
    case alreadyWateredToday(plantName: String)
    case invalidWateringInterval
    case emptyPlantName
    case saveFailed

    // all the error switch cases and the messages they deliver when they are triggered
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
