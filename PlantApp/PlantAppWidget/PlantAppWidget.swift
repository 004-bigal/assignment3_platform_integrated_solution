//
//  PlantAppWidget.swift
//  PlantApp
//
//  Created by Alik Orgun on 9/10/2026.
//

import WidgetKit
import SwiftUI
import Foundation

struct PlantEntry: TimelineEntry {
    let date: Date
    let plantsNeedingWater: [PlantModel]
}

struct PlantProvider: TimelineProvider {
    func placeholder(in context: Context) -> PlantEntry {
        PlantEntry(date: .now, plantsNeedingWater: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (PlantEntry) -> Void) {
        Task { completion(await fetchEntry()) }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PlantEntry>) -> Void) {
        Task {
            let entry = await fetchEntry()
            let next = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }

    private func fetchEntry() async -> PlantEntry {
        let repo = CoreRepo()
        let plants = (try? await repo.fetchPlantsNeedingWater()) ?? []
        return PlantEntry(date: .now, plantsNeedingWater: plants)
    }
}

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

@main
struct PlantAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        PlantAppWidget()
    }
}

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
