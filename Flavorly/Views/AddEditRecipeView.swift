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
    @State private var ingredients = ""
    @State private var text = ""
    @State private var author = ""
    @State private var tags: [Tag] = []
    @State private var newTags: [Tag] = []
    @State private var tagTitle = ""
    
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
                        TextField(LocalizedStringKey("recipe.name"), text: $title)
                            .accessibilityIdentifier("recipeNameTextField")
                        TextField(LocalizedStringKey("author.name"), text: $author)
                            .accessibilityIdentifier("authorsNameTextField")
                    }
                    
                    Section {
                        TextEditor(text: $ingredients)
                            .accessibilityIdentifier("ingredientsTextField")
                    } header: {
                        Text(LocalizedStringKey("ingredient.list"))
                    }
                    
                    Section {
                        TextEditor(text: $text)
                            .accessibilityIdentifier("recipeTextField")
                    } header: {
                        Text(LocalizedStringKey("recipe.text"))
                    }
                    Section {
                        List {
                            ForEach($tags) { $tag in
                                Button(tag.title!) {
                                    removeTagFromRecipe(recipe: recipe!, tag: tag)
                                    tags.removeAll { $0.title == tag.title }
                                }
                                }
                            }
                            ForEach($newTags) { $tag in
                                Button(tag.title!) {
                                    newTags.removeAll { $0.title == tag.title }
                                }
                                }
                        } header: {
                        Text("your tags")
                    }
                    
                    Section {
                        
                        HStack {
                            TextField("Add them one by one", text:$tagTitle)
                            Button {
                                addTagItem(tagTitle: tagTitle)
                                tagTitle = ""
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color.backgroundGreen)
                                .font(.title2)
                            }
                        }
                        
                    } header: {
                        Text("add tags to your recie")
                    }
                    
                    Section {
                        Button(newRecipe ? LocalizedStringKey("add.button") : LocalizedStringKey("update.button")) {
                            if newRecipe {
                                addNewRecipe(title: title, author: author, ingredients: ingredients, text: text, newTags: newTags, moc: moc)
                            } else {
                                editSavedRecipe(recipe: recipe, title: title, author: author, ingredients: ingredients, text: text, newTags: newTags, moc: moc)
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
                            Text(NSLocalizedString("recipe.add", comment: "").uppercased())
                            .padding(95)
                        } else {
                            Text(NSLocalizedString("recipe.edit", comment: "").uppercased())
                            .padding(95)
                        }
                    }
                }.onAppear {
                    newRecipe = (recipe == nil) // here we check if we passed recipe to this view
                    // and if there is recipe that you are passing you assign those properties of recipe to your view fields
                    if newRecipe == false {
                        title = recipe?.title ?? ""
                        author = recipe?.author ?? ""
                        ingredients = recipe?.ingredients ?? ""
                        text = recipe?.text ?? ""
                        tags = recipe?.tagArray ?? []
                    }
                }
            }
        }
    private func addTagItem(tagTitle: String) {
        let tag = Tag(context: moc)
        tag.id = UUID()
        tag.title = tagTitle
        
        newTags.append(tag)
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRecipeView(recipe: nil)
    }
}
func addNewRecipe (title: String, author: String, ingredients: String, text: String, newTags: [Tag], moc: NSManagedObjectContext) {
    let newRecipe = Recipe(context: moc)
    newRecipe.id = UUID()
    newRecipe.title = title
    newRecipe.author = author
    newRecipe.ingredients = ingredients
    newRecipe.text = text
    
    newTags.forEach { tag in
        newRecipe.addToRecipeToTag(tag)
    }
    
    try? moc.save()
}

func removeTagFromRecipe (recipe: Recipe, tag: Tag) {
    recipe.removeFromRecipeToTag(tag)
}
func editSavedRecipe (recipe: Recipe?, title: String, author: String, ingredients: String, text: String, newTags: [Tag], moc: NSManagedObjectContext) {
    recipe?.title = title
    recipe?.author = author
    recipe?.ingredients = ingredients
    recipe?.text = text
    
    newTags.forEach { tag in
        recipe?.addToRecipeToTag(tag)
    }
    
    try? moc.save()
}
