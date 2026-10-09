//
//  AddAPlantView.swift
//  PlantApp
//
//  Created by Alik Orgun on 9/10/2026.
//

import SwiftUI

struct AddAPlantView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddAPlantViewModel()
    let onSaved: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $viewModel.name)
                TextField("Location", text: $viewModel.location)
                Stepper("Water every \(viewModel.intervalDays) days",
                        value: $viewModel.intervalDays, in: 1...30)
                if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red)
                }
            }
            .navigationTitle("Add Plant")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.save()
                            if viewModel.didSave {
                                onSaved()
                                dismiss()
                            }
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
