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
    @State private var type = NSLocalizedString("Main", comment: "")
    @State private var ingredients = ""
    @State private var text = ""
    @State private var author = ""
    @State private var diet = NSLocalizedString("Omnivore", comment: "")
    @State private var occasion = NSLocalizedString("Everyday", comment: "")
    
    let diets = [NSLocalizedString("Vegetarian", comment: ""),
                 NSLocalizedString("Vegan", comment: ""),
                 NSLocalizedString("Gluten free", comment: ""),
                 NSLocalizedString("Dairy free", comment: ""),
                 NSLocalizedString("Pescatarian", comment: ""),
                 NSLocalizedString("Omnivore", comment: ""),
                 NSLocalizedString("Nut free", comment: ""),
                ]
    let types = [NSLocalizedString("Soup", comment: ""),
                 NSLocalizedString("Salad", comment: ""),
                 NSLocalizedString("Main", comment: ""),
                 NSLocalizedString("Dessert", comment: ""),
                 NSLocalizedString("Side", comment: ""),
                 NSLocalizedString("Breakfast", comment: ""),
                 NSLocalizedString("Lunch", comment: ""),
                 NSLocalizedString("Dinner", comment: ""),
                 NSLocalizedString("Juice", comment: ""),
                 ]
    let occasions = [NSLocalizedString("Christmas", comment: ""),
                     NSLocalizedString("New Years", comment: ""),
                     NSLocalizedString("Birthday", comment: ""),
                     NSLocalizedString("Easter", comment: ""),
                     NSLocalizedString("Everyday", comment: ""),
                    ]
    
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
                        TextField(LocalizedStringKey("Recipe name"), text: $title)
                            .accessibilityIdentifier("recipeNameTextField")
                        TextField(LocalizedStringKey("Author's name"), text: $author)
                            .accessibilityIdentifier("authorsNameTextField")
                        
                        Picker(NSLocalizedString("Diet", comment: ""), selection: $diet) {
                            ForEach(diets, id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                        Picker(NSLocalizedString("Type", comment: ""), selection: $type) {
                            ForEach(types, id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                        Picker(NSLocalizedString("Occasion", comment: ""), selection: $occasion) {
                            ForEach(occasions, id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                    }
                    Section {
                        TextEditor(text: $ingredients)
                            .accessibilityIdentifier("ingredientsTextField")
                    } header: {
                        Text(LocalizedStringKey("Write the ingredients"))
                    }
                    Section {
                        TextEditor(text: $text)
                            .accessibilityIdentifier("recipeTextField")
                    } header: {
                        Text(LocalizedStringKey("recipe"))
                    }
                    Section {
                        Button(newRecipe ? LocalizedStringKey("Add") : LocalizedStringKey("Update")) {
                            if newRecipe {
                                addNewRecipe(title: title, author: author, diet: diet, occasion: occasion, ingredients: ingredients, type: type, text: text, moc: moc)
                            } else {
                                editSavedRecipe(recipe: recipe, title: title, author: author, diet: diet, occasion: occasion, ingredients: ingredients, type: type, text: text, moc: moc)
                            }
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
                            Image(systemName: "x.circle.fill")
                               .foregroundStyle(Color.backgroundRed)
                        }
                        if newRecipe == true {
                            Text(NSLocalizedString("Add Recipe", comment: "").uppercased())
                            .padding(95)
                        } else {
                            Text(NSLocalizedString("Edit Recipe", comment: "").uppercased())
                            .padding(95)
                        }
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
            }
        }
    
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRecipeView(recipe: nil)
    }
}
func addNewRecipe (title: String, author: String, diet: String, occasion: String, ingredients: String, type: String, text: String, moc: NSManagedObjectContext) {
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
}
func editSavedRecipe (recipe: Recipe?, title: String, author: String, diet: String, occasion: String, ingredients: String, type: String, text: String, moc: NSManagedObjectContext) {
    recipe?.title = title
    recipe?.author = author
    recipe?.diet = diet
    recipe?.occasion = occasion
    recipe?.ingredients = ingredients
    recipe?.type = type
    recipe?.text = text
    
    try? moc.save()
}
