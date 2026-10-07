//
//  AddAPlantViewModel.swift
//  PlantApp
//
//  Created by Alik Orgun on 8/10/2026.
//

import Foundation
import Observation

@Observable
class AddAPlantViewModel {
    let addUseCase: AddPlantUseCase
    
    var name = ""
    var location = ""
    var intervalDays = 3
    var errorMessage: String?
    var didSave = false

    init(repository: PlantRepo = CoreRepo()) {
        self.addUseCase = AddPlantUseCase(repository: repository)
    }

    func save() async {
        do {
            try await addUseCase.execute(
                name: name,
                location: location,
                intervalDays: intervalDays
            )
            didSave = true
            errorMessage = nil
        } catch let error as ErrorPlant {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Couldn't save this plant."
        }
    }
}
