//
//  EditRecipeView.swift
//  Flavorly
//
//  Created by Timea Bartha on 23/8/23.
//
import CoreData
import SwiftUI

struct EditRecipeView: View {
    let editRecipe: Recipe
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
     private var title = ""
     private var type = ""
     private var ingredients = ""
     private var recipe = ""
     private var author = ""
     private var hardness = 3
     private var diet = ""
     private var occasion = ""
    
    var body: some View {
        NavigationView {
                Form {
                    Section {
                        TextField("Recipe name", text: recipe.title)
                        TextField("Author's name", text: recipe.author)
                        
                        Picker("Diet", selection: recipe.diet) {
                            Text("").tag("")
                            ForEach(recipe.diet, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Type", selection: recipe.type) {
                            Text("").tag("")
                            ForEach(recipe.type, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Occasion", selection: recipe.occasion) {
                            Text("").tag("")
                            ForEach(recipe.occasion, id: \.self) {
                                Text($0)
                            }
                        }
                        
                    }
                    
                    Section {
                        HardnessView(hardness: recipe.hardness)
                    } header: {
                        Text("How hard is this?")
                    }
                    
                    Section {
                        TextEditor(text: recipe.ingredients)
                    } header: {
                        Text("Write the ingredients")
                    }
                    Section {
                        TextEditor(text: recipe.recipe)
                    } header: {
                        Text("recipe")
                    }
                    Section {
                        Button("Save") {
                            
                            try? moc.save()
                            dismiss()
                        }
                        
                    }
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


