//
//  AddRecipeView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI
import CoreData

struct AddEditRecipeView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    let recipe: Recipe?
    
    @State private var newRecipe = false
    @State private var title = ""
    @State private var ingredients: [String] = []
    @State private var currentIngredient = ""
    @State private var text = ""
    @State private var author = ""
    @State private var tags: [Tag] = []
    @State private var tagTitle = ""
    @State private var timestamp = Date()
    
    @AppStorage("didLaunchBefore") private var onboardingDone = false
    
    var body: some View {
        Group {
            if !onboardingDone {
                OnboardingView {
                    self.onboardingDone = true
                }
            } else {
                NavigationStack {
                    Form {
                        // Recipe Info Section
                        Section {
                            TextField("Recipe Name", text: $title)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("Author", text: $author)
                                .textFieldStyle(.roundedBorder)
                            
                            DatePicker("Created Date",
                                      selection: $timestamp,
                                      displayedComponents: .date)
                        }
                        
                        // Ingredients Section
                        Section("Ingredients") {
                            ForEach(ingredients.indices, id: \.self) { index in
                                Text(ingredients[index])
                            }
                            .onDelete(perform: deleteIngredient)
                            
                            HStack {
                                TextField("Add ingredient...", text: $currentIngredient)
                                    .textFieldStyle(.roundedBorder)
                                
                                Button {
                                    addIngredient()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                .disabled(currentIngredient.isEmpty)
                            }
                        }
                        
                        // Instructions Section
                        Section("Instructions") {
                            TextEditor(text: $text)
                                .frame(minHeight: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Tags Section (always editable)
                        Section("Tags") {
                            // Use indices to ensure proper identification
                            ForEach(Array(zip(tags.indices, tags)), id: \.1.id) { index, tag in
                                if let title = tag.title {
                                    HStack {
                                        Text(title)
                                        Spacer()
                                        Button {
                                            // Remove only this specific tag
                                            removeTag(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue.opacity(0.1))
                                    )
                                }
                            }
                            
                            // Add tag field
                            HStack {
                                TextField("Add tag...", text: $tagTitle)
                                Button {
                                    addTagItem(tagTitle: tagTitle)
                                    tagTitle = ""
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                }
                                .disabled(tagTitle.isEmpty)
                            }
                        }
                    }
                    .navigationTitle(newRecipe ? "New Recipe" : "Edit Recipe")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // Consistent back button for both modes
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                            }
                        }
                        
                        // Save button
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                saveRecipe()
                            }
                            .disabled(title.isEmpty || author.isEmpty || ingredients.isEmpty || text.isEmpty)
                            .bold()
                        }
                    }
                    .onAppear { setupInitialValues() }
                }
            }
        }
    }
    
    // Tag View (removable in all cases)
    private struct TagView: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            HStack(spacing: 4) {
                Text(title)
                Button(action: action) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.blue.opacity(0.1))
            .overlay(
                Capsule()
                    .stroke(Color.blue, lineWidth: 1)
            ))
        }
    }
    
    private func setupInitialValues() {
        newRecipe = (recipe == nil)
        if let recipe = recipe {
            title = recipe.title ?? ""
            author = recipe.author ?? ""
            ingredients = (recipe.ingredients ?? "").components(separatedBy: "\n").filter { !$0.isEmpty }
            text = recipe.text ?? ""
            tags = recipe.tagArray
            timestamp = recipe.timestamp ?? Date()
        }
    }
    
    private func saveRecipe() {
        if newRecipe {
            let newRecipe = Recipe(context: moc)
            newRecipe.id = UUID()
            newRecipe.title = title
            newRecipe.author = author
            newRecipe.ingredients = ingredients.joined(separator: "\n")
            newRecipe.text = text
            newRecipe.timestamp = timestamp
            
            tags.forEach { newRecipe.addToRecipeToTag($0) }
        } else if let recipe = recipe {
            recipe.title = title
            recipe.author = author
            recipe.ingredients = ingredients.joined(separator: "\n")
            recipe.text = text
            recipe.timestamp = timestamp
            let currentRecipeTags = (recipe.recipeToTag as? Set<Tag>) ?? []
            
            // Remove tags no longer in the list
            for tag in currentRecipeTags {
                if !tags.contains(where: { $0.id == tag.id }) {
                    recipe.removeFromRecipeToTag(tag)
                }
            }
            
            // Add new tags that weren't previously associated
            for tag in tags {
                if !currentRecipeTags.contains(where: { $0.id == tag.id }) {
                    recipe.addToRecipeToTag(tag)
                }
            }
        }
        
        try? moc.save()
        dismiss()
    }
    
    private func addIngredient() {
        withAnimation {
            ingredients.append(currentIngredient)
            currentIngredient = ""
        }
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        withAnimation {
            ingredients.remove(atOffsets: offsets)
        }
    }
    private func removeTag(at index: Int) {
            guard index < tags.count else { return }
            
            let tagToRemove = tags[index]
            
            // Only remove from this recipe's tags array
            // Don't delete from CoreData
            withAnimation {
                _ = tags.remove(at: index)
            }
            
            // If editing existing recipe, remove the relationship
            if let recipe = recipe {
                recipe.removeFromRecipeToTag(tagToRemove)
            }
        }
    private func addTagItem(tagTitle: String) {
            let trimmedTitle = tagTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedTitle.isEmpty else { return }
            
            let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", trimmedTitle)
            
            if let existingTag = try? moc.fetch(fetchRequest).first {
                // Use existing tag if found
                if !tags.contains(where: { $0.id == existingTag.id }) {
                    withAnimation {
                        tags.append(existingTag)
                    }
                }
            } else {
                // Create new tag
                let newTag = Tag(context: moc)
                newTag.id = UUID()
                newTag.title = trimmedTitle
                withAnimation {
                    tags.append(newTag)
                }
            }
        }
}

// MARK: - Wrapping HStack for Tags
struct WrappingHStack<Model, Content>: View where Model: Hashable, Content: View {
    var models: [Model]
    var content: (Model) -> Content
    
    init(_ models: [Model], id: KeyPath<Model, some Hashable>, @ViewBuilder content: @escaping (Model) -> Content) {
        self.models = models
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(models, id: \.self) { model in
                content(model)
                    .padding([.trailing, .bottom], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if model == models.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if model == models.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }
}
