//
//  PlantAppTests.swift
//  PlantAppTests
//
//  Created by Alik Orgun on 7/10/2026.
//

import XCTest
@testable import PlantApp

final class UseCaseTests: XCTestCase {

    // The WaterPlantUseCase

    func testWaterPlant_recordsWateringForPlantNotWateredToday() async throws {
        let repo = FakeRepo()
        let plant = PlantModel(
            name: "Monstera",
            location: "Living room",
            wateringIntervalDays: 3
        )
        repo.plants = [plant]

        let useCase = WaterPlantUseCase(repository: repo)
        try await useCase.execute(plantID: plant.id)

        XCTAssertEqual(repo.waterings.count, 1)
    }

    func testWaterPlant_throwsAlreadyWateredToday_whenWateredTwiceInOneDay() async {
        let repo = FakeRepo()
        let plant = PlantModel(
            name: "Fern",
            location: "Bathroom",
            wateringIntervalDays: 2,
            lastWatered: .now
        )
        repo.plants = [plant]

        let useCase = WaterPlantUseCase(repository: repo)

        do {
            try await useCase.execute(plantID: plant.id)
            XCTFail("Expected alreadyWateredToday error")
        } catch let error as ErrorPlant {
            XCTAssertEqual(error, .alreadyWateredToday(plantName: "Fern"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testWaterPlant_throwsPlantNotFound_forUnknownID() async {
        let repo = FakeRepo()
        let useCase = WaterPlantUseCase(repository: repo)

        do {
            try await useCase.execute(plantID: UUID())
            XCTFail("Expected plantNotFound error")
        } catch let error as ErrorPlant {
            XCTAssertEqual(error, .thePlantNotFound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // The AddPlantUseCase

    func testAddPlant_rejectsIntervalBelowOneDay() async {
        let repo = FakeRepo()
        let useCase = AddPlantUseCase(repository: repo)

        do {
            try await useCase.execute(name: "Cactus", location: "Desk", intervalDays: 0)
            XCTFail("Expected invalidWateringInterval error")
        } catch let error as ErrorPlant {
            XCTAssertEqual(error, .invalidWateringInterval)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testAddPlant_savesPlantWithValidInterval() async throws {
        let repo = FakeRepo()
        let useCase = AddPlantUseCase(repository: repo)

        try await useCase.execute(name: "Pothos", location: "Shelf", intervalDays: 7)

        XCTAssertEqual(repo.plants.count, 1)
        XCTAssertEqual(repo.plants.first?.plantName, "Pothos")
    }

    // The FetchPlantsNeedingWaterUseCase

    func testFetchPlantsNeedingWater_returnsOnlyOverduePlants() async throws {
        let repo = FakeRepo()

        let thirsty = PlantModel(
            name: "Thirsty",
            location: "Kitchen",
            wateringIntervalDays: 2,
            lastWatered: nil
        )
        let fresh = PlantModel(
            name: "Fresh",
            location: "Bathroom",
            wateringIntervalDays: 5,
            lastWatered: .now
        )
        repo.plants = [thirsty, fresh]

        let useCase = FetchThePlantsNeedingWaterUseCase(repository: repo)
        let result = try await useCase.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.plantName, "Thirsty")
    }
}
