//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 31/7/25.
//
import SwiftUI
import CoreData

struct RecipeEditView: View {
    @Binding var parsedRecipe: ParsedRecipe
    var onSave: () -> Void
    var onCancel: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe Title")) {
                    TextField("Enter recipe title", text: $parsedRecipe.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: HStack {
                    Text("Ingredients")
                    Spacer()
                    Text("(\(parsedRecipe.ingredients.filter { !$0.isEmpty }.count))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }) {
                    ForEach($parsedRecipe.ingredients.indices, id: \.self) { index in
                        TextField("Ingredient", text: $parsedRecipe.ingredients[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .onDelete { indices in
                        parsedRecipe.ingredients.remove(atOffsets: indices)
                        ensureMinimumIngredients()
                    }
                    
                    Button {
                        parsedRecipe.ingredients.append("")
                    } label: {
                        Label("Add Ingredient", systemImage: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: HStack {
                    Text("Instructions")
                    Spacer()
                    Text("(\(parsedRecipe.instructions.filter { !$0.isEmpty }.count))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }) {
                    ForEach($parsedRecipe.instructions.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Step \(index + 1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: $parsedRecipe.instructions[index])
                                .frame(minHeight: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indices in
                        parsedRecipe.instructions.remove(atOffsets: indices)
                        ensureMinimumInstructions()
                    }
                    
                    Button {
                        parsedRecipe.instructions.append("")
                    } label: {
                        Label("Add Step", systemImage: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        cleanupEmptyFields()
                        onSave()
                        dismiss()
                    }
                    .disabled(parsedRecipe.title.isEmpty)
                }
            }
            .onAppear {
                setupInitialFields()
            }
        }
    }
    
    private func setupInitialFields() {
        // Ensure we have at least one empty field in each section
        ensureMinimumIngredients()
        ensureMinimumInstructions()
        
        // Set default title if empty
        if parsedRecipe.title.isEmpty {
            parsedRecipe.title = "Imported Recipe"
        }
    }
    
    private func ensureMinimumIngredients() {
        if parsedRecipe.ingredients.isEmpty {
            parsedRecipe.ingredients = [""]
        } else if parsedRecipe.ingredients.last != "" {
            parsedRecipe.ingredients.append("")
        }
    }
    
    private func ensureMinimumInstructions() {
        if parsedRecipe.instructions.isEmpty {
            parsedRecipe.instructions = [""]
        } else if parsedRecipe.instructions.last != "" {
            parsedRecipe.instructions.append("")
        }
    }
    
    private func cleanupEmptyFields() {
        // Remove empty ingredients except keep one if all are empty
        parsedRecipe.ingredients = parsedRecipe.ingredients.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        if parsedRecipe.ingredients.isEmpty {
            parsedRecipe.ingredients = [""]
        }
        
        // Remove empty instructions except keep one if all are empty
        parsedRecipe.instructions = parsedRecipe.instructions.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        if parsedRecipe.instructions.isEmpty {
            parsedRecipe.instructions = [""]
        }
    }
}
