//
//  AddRecipeView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import CoreData
import SwiftUI

struct AddRecipeView: View {
    
    @Environment(\.managedObjectContext) var moc //environment property to store our managed object context:
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var type = ""
    @State private var ingredients = ""
    @State private var recipe = ""
    @State private var author = ""
    @State private var hardness = 3
    @State private var diet = ""
    @State private var occasion = ""
    
    let diets = ["Vegetarian", "Vegan", "Gluten free", "Dairy free", "Pescatarian", "Omnivore"]
    let types = ["Soup", "Salad", "Main", "Dessert", "Side", "Breakfast", "Lunch", "Dinner"]
    let occasions = ["Christmas", "New Years", "Birthday", "Easter", "Everyday"]
    
    var hasValidName: Bool {
        if title.isEmpty || author.isEmpty {
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationView {
                Form {
                    Section {
                        TextField("Recipe name", text: $title)
                        TextField("Author's name", text: $author)
                        
                        Picker("Diet", selection: $diet) {
                            Text("").tag("")
                            ForEach(diets, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Type", selection: $type) {
                            Text("").tag("")
                            ForEach(types, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Occasion", selection: $occasion) {
                            Text("").tag("")
                            ForEach(occasions, id: \.self) {
                                Text($0)
                            }
                        }
                        
                    }
                    
                    Section {
                        HardnessView(hardness: $hardness)
                    } header: {
                        Text("How hard is this?")
                    }
                    
                    Section {
                        TextEditor(text: $ingredients)
                    } header: {
                        Text("Write the ingredients")
                    }
                    Section {
                        TextEditor(text: $recipe)
                    } header: {
                        Text("recipe")
                    }
                    Section {
                        Button("Save") {
                            let newRecipe = Recipe(context: moc)
                            newRecipe.id = UUID()
                            newRecipe.title = title
                            newRecipe.author = author
                            newRecipe.hardness = Int16(hardness)
                            newRecipe.diet = diet
                            newRecipe.occasion = occasion
                            newRecipe.ingredients = ingredients
                            newRecipe.type = type
                            newRecipe.recipe = recipe
                            
                            try? moc.save()
                            dismiss()
                        }
                        
                    }
                    .disabled(hasValidName == false)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("Back", systemImage: "xmark")
                        }
                        Text("Add recipe".uppercased())
                            .padding(95)
                            
                    }
                }
            }
        }
    
    
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
