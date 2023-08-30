//
//  AddRecipeView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import CoreData
import SwiftUI

struct AddEditRecipeView: View {
    
    @Environment(\.managedObjectContext) var moc //environment property to store our managed object context:
    @Environment(\.dismiss) var dismiss
    
    let recipe: Recipe?
    @State private var newRecipe = false
    
    @State private var title = ""
    @State private var type = ""
    @State private var ingredients = ""
    @State private var text = ""
    @State private var author = ""
    @State private var diet = ""
    @State private var occasion = ""
    
    let diets = ["Vegetarian", "Vegan", "Gluten free",  "Dairy free", "Pescatarian", "Omnivore"]
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
                            ForEach(diets, id: \.self) {
                                Text($0)
                            }
                        }
                            
                        Picker("Type", selection: $type) {
                            ForEach(types, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Occasion", selection: $occasion) {
                            ForEach(occasions, id: \.self) {
                                Text($0)
                            }
                        }
                        
                    }
                    
                    Section {
                        TextEditor(text: $ingredients)
                    } header: {
                        Text("Write the ingredients")
                    }
                    Section {
                        TextEditor(text: $text)
                    } header: {
                        Text("recipe")
                    }
                    Section {
                        Button(newRecipe ? "Add" : "Update") {
                            if newRecipe {
                                let newRecipe = Recipe(context: moc)
                                newRecipe.id = UUID()
                                newRecipe.title = title
                                newRecipe.author = author
                                newRecipe.diet = diet
                                newRecipe.occasion = occasion
                                newRecipe.ingredients = ingredients
                                newRecipe.type = type
                                newRecipe.text = text
                                
                                try? moc.save()
                                dismiss()
                            } else {
                                recipe?.title = title
                                recipe?.author = author
                                recipe?.diet = diet
                                recipe?.occasion = occasion
                                recipe?.ingredients = ingredients
                                recipe?.type = type
                                recipe?.text = text
                                
                                try? moc.save()
                                dismiss()
                            }
                            
                        }

                    }
                    .disabled(hasValidName == false)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("Back", systemImage: "x.circle.fill")
                                .foregroundStyle(.red)
                        }
                        Text("Add recipe".uppercased())
                            .padding(95)
                            
                    }
                }.onAppear {
                    newRecipe = (recipe == nil) // here we check if we passed recipe to this view
                    // and if there is recipe that you are passing you assign those properties of recipe to your view fields
                        
                    if newRecipe == false {
                        title = recipe?.title ?? ""
                        author = recipe?.author ?? ""
                        diet = recipe?.diet ?? diets[0]
                        type = recipe?.type ?? types[0]
                        occasion = recipe?.occasion ?? occasions[0]
                        ingredients = recipe?.ingredients ?? ""
                        text = recipe?.text ?? ""
                    } else {
                        diet = diets[0]
                        type = types[0]
                        occasion = occasions[0]
                    }
                }
            }.frame(maxWidth: .infinity)
            .background(Color("BackgrounBeige"))
        }
        
    
    
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRecipeView(recipe: nil)
    }
}
