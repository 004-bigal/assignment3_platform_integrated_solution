//
//  PlantAppWidget.swift
//  PlantApp
//
//  Created by Alik Orgun on 9/10/2026.
//

import WidgetKit
import SwiftUI
import Foundation

// the data a widget renders
struct PlantEntry: TimelineEntry {
    let date: Date
    let plantsNeedingWater: [PlantModel]
}

// this structure supplies the WidgetKit with a timeline of entries describing the current state of the users
// plants
struct PlantProvider: TimelineProvider {
    // placeholder function
    func placeholder(in context: Context) -> PlantEntry {
        PlantEntry(date: .now, plantsNeedingWater: [])
    }

    // snapshot for transient displays
    func getSnapshot(in context: Context, completion: @escaping (PlantEntry) -> Void) {
        Task { completion(await fetchEntry()) }
    }

    // asks for current entry and schedules the next refresh
    func getTimeline(in context: Context, completion: @escaping (Timeline<PlantEntry>) -> Void) {
        Task {
            let entry = await fetchEntry()
            let next = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }

    // fetches plants needing water
    func fetchEntry() async -> PlantEntry {
        let repo = CoreRepo()
        let plants = (try? await repo.fetchPlantsNeedingWater()) ?? []
        return PlantEntry(date: .now, plantsNeedingWater: plants)
    }
}

// view rendered in the widget, displays a count of plants
struct PlantAppWidgetEntryView: View {
    var entry: PlantEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("🪴 Plants")
                .font(.caption)
                .foregroundStyle(.secondary)

            if entry.plantsNeedingWater.isEmpty {
                Text("All watered")
                    .font(.headline)
            } else {
                Text("\(entry.plantsNeedingWater.count) need water")
                    .font(.headline)
                if let first = entry.plantsNeedingWater.first {
                    Text(first.plantName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// entry point for extension
@main
struct PlantAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        PlantAppWidget()
    }
}

// widget config
struct PlantAppWidget: Widget {
    let kind = "PlantAppWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PlantProvider()) { entry in
            PlantAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Plants Needing Water")
        .description("See which plants need watering today.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}
