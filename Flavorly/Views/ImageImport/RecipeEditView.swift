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
    @EnvironmentObject var themeManager: ThemeManager
    var onSave: () -> Void
    var onCancel: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
            NavigationStack {
                Form {
                    Section(header: Text("Recipe Title")) {
                        TextField("Enter recipe title", text: $parsedRecipe.title)
                    }
                    
                    Section(header: HStack {
                        Text("Ingredients")
                            .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        Spacer()
                        Text("(\(parsedRecipe.ingredients.filter { !$0.isEmpty }.count))")
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                            .font(.caption)
                    }) {
                        ForEach($parsedRecipe.ingredients.indices, id: \.self) { index in
                            HStack {
                                TextField("Ingredient", text: $parsedRecipe.ingredients[index])
                                   
                                
                                Button(action: {
                                    parsedRecipe.ingredients.remove(at: index)
                                    ensureMinimumIngredients()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(themeManager.currentTheme.deleteButtonColor)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .onDelete { indices in
                            parsedRecipe.ingredients.remove(atOffsets: indices)
                            ensureMinimumIngredients()
                        }
                        
                        Button {
                            parsedRecipe.ingredients.append("")
                        } label: {
                            Label("Add Ingredient", systemImage: "plus.circle.fill")
                                .foregroundColor(themeManager.currentTheme.addButtonColor)
                        }
                    }
                    
                    Section(header: HStack {
                        Text("Instructions")
                        Spacer()
                        Text("(\(parsedRecipe.instructions.filter { !$0.isEmpty }.count))")
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                            .font(.caption)
                    }) {
                        ForEach($parsedRecipe.instructions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Step \(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                                    Spacer()
                                    Button(action: {
                                        parsedRecipe.instructions.remove(at: index)
                                        ensureMinimumInstructions()
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(themeManager.currentTheme.deleteButtonColor)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                TextEditor(text: $parsedRecipe.instructions[index])
                                    .frame(minHeight: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(themeManager.currentTheme.secondaryTextColor, lineWidth: 1)
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
                                .foregroundColor(themeManager.currentTheme.addButtonColor)
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
                        .foregroundColor(themeManager.currentTheme.deleteButtonColor)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            cleanupEmptyFields()
                            onSave()
                            dismiss()
                        }
                        .disabled(parsedRecipe.title.isEmpty)
                        .foregroundColor(themeManager.currentTheme.addButtonColor)
                    }
                }
                .onAppear {
                    setupInitialFields()
                }
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
