# Assignemt 3: Platform integrated solution for PlantApp
For Assessment Task 3. For the subject 40005 Advanced iOS Development, Spring 2026.

## Description

A plant-sitting companion for keeping houseplants alive during long absences.

## Context of the Application

Whenever a friend or neighbour travels, a plant sitter takes over care of their
houseplant collection. Maybe with different plants on different schedules, a paper list
gets lost. Or notes fall behind furniture and by the second week plants are
dying. PlantApp tracks each plants schedule, surfaces what needs water today
on a Lock Screen widget and accepts photos shared from other apps.

## Application Architecture

MVVM schema:

- **Views** — 5 screens
- **ViewModel** — holds screen state & calls Use Cases
- **Use Cases** — enforce domain ruless & throw typed errors
- **Repository** — `PlantRepository` protocol with Core Data and Fake impls
- **Core Data** — `PlantEntity` and `WateringLogEntity` with a to-many relationship

## Extensions

- **WidgetKit Widget** — Small and Lock Screen widgets showing plants needing
  water today. Reads from the App Group shared container. The main app calls
  `WidgetCenter.reloadAllTimelines()` after every watering.
- **Share Extension** — Accepts images from the system share sheet. Saves them
  to the App Group's `shared-images/` directory for the main app to use.

## Database

Core Data: Single user. Offline first. No account required. CloudKit would
add complexity for zero benefit in this domain.

## App Group

`group.com.alikorgun.plant2026`

## Setup

1. Clone the repository
2. Open `PlantApp.xcodeproj` in Xcode
3. Set your signing team on all three targets
4. Ensure the App Group `group.com.alikorgun.plant2026` is enabled on all targets
5. Run on an iPhone Simulator

## Tests

`Cmd+U` runs 6 unit tests covering the 3 Use Cases using a fake repository.
