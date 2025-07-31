//
//  ImportHistoryView.swift
//  Flavourly
//
//  Created by Timea Bartha on 31/7/25.
//
import SwiftUI

struct ImportHistoryView: View {
    @Binding var history: [ImportedRecipe]
    var onSelect: (ParsedRecipe) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(history) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text("\(item.ingredients.count) ingredients • \(item.instructions.count) steps")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(item.date.formatted())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        let recipe = ParsedRecipe(
                            title: item.title,
                            ingredients: item.ingredients,
                            instructions: item.instructions
                        )
                        onSelect(recipe)
                        dismiss()
                    }
                }
                .onDelete { indices in
                    history.remove(atOffsets: indices)
                }
            }
            .navigationTitle("Import History")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
