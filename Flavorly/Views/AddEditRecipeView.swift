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
    @State private var tagTitle = ""
    
    var hasValidName: Bool {
        if title.isEmpty || author.isEmpty || ingredients.isEmpty || text.isEmpty {
            return false
        }
        return true
    }
    
    @AppStorage("didLaunchBefore") private var onboardingDone = false
    
    var body: some View {
        Group {
            if !onboardingDone {
                OnboardingView {
                    self.onboardingDone = true
                }
            } else {
                NavigationView {
                    Form {
                        Section {
                            TextField(LocalizedStringKey("recipe.name"), text: $title)
                                .accessibilityIdentifier("recipeNameTextField")
                                .padding(5)
                                .overlay(
                                       RoundedRectangle(cornerRadius: 14)
                                           .stroke(Color.backgroundRed.opacity(title == "" ? 0.50 : 0.0), lineWidth: 2)
                                   )
                                
                            TextField(LocalizedStringKey("author.name"), text: $author)
                                .accessibilityIdentifier("authorsNameTextField")
                                .padding(5)
                                .overlay(
                                       RoundedRectangle(cornerRadius: 14)
                                           .stroke(Color.backgroundRed.opacity(author == "" ? 0.50 : 0.0), lineWidth: 2)
                                   )
                                
                        }
                        
                        Section {
                            TextEditor(text: $ingredients)
                                .accessibilityIdentifier("ingredientsTextField")
                                .padding(5)
                                .overlay(
                                       RoundedRectangle(cornerRadius: 14)
                                           .stroke(Color.backgroundRed.opacity(ingredients == "" ? 0.50 : 0.0), lineWidth: 2)
                                   )
                        } header: {
                            Text(LocalizedStringKey("ingredient.list"))
                        }
                        
                        Section {
                            TextEditor(text: $text)
                                .accessibilityIdentifier("recipeTextField")
                                .padding(5)
                                .overlay(
                                       RoundedRectangle(cornerRadius: 14)
                                           .stroke(Color.backgroundRed.opacity(text == "" ? 0.50 : 0.0), lineWidth: 2)
                                   )
                        } header: {
                            Text(LocalizedStringKey("recipe.text"))
                        }
                        //MARK: TagView
                        
                        List {
                            ForEach($tags) { $tag in
                                if tag.title != nil { // when deduplicating in core data the tag intance in the tags array becomes null
                                    Button(tag.title!) {
                                        if recipe != nil {
                                            removeTagFromRecipe(recipe: recipe!, tag: tag)
                                        }
                                        tags.removeAll { $0.title == tag.title }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.primary)
                                }
                            }
                        }
                        
                        Section {
                            HStack{
                                TextField("add.tags.separately", text:$tagTitle)
                                    .textCase(.lowercase)
                                //MARK: Add TAG button
                                Button {
                                    addTagItem(tagTitle: tagTitle)
                                    tagTitle = ""
                                    //hides keyboard after each add
                                    self.endEditing()
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(Color.backgroundGreen)
                                        .font(.title2)
                                }.disabled(tagTitle == "")
                            }
                        } header: {
                            Text("add.tagToRecipe")
                        }
                        //MARK: ADD/EDIT button
                        Section {
                            Button(newRecipe ? LocalizedStringKey("add.button") : LocalizedStringKey("update.button")) {
                                if newRecipe {
                                    addNewRecipe(title: title, author: author, ingredients: ingredients, text: text, newTags: tags, moc: moc)
                                } else {
                                    editSavedRecipe(recipe: recipe, title: title, author: author, ingredients: ingredients, text: text, newTags: tags, moc: moc)
                                }
                                dismiss()
                            }
                        }
                        .disabled(hasValidName == false)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            //MARK: Toolbar buttons
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(Color.backgroundRed)
                                    .font(.title3)
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
                        //MARK: OnAppear NewRecipe ?? UpdatedRecipe
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
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    //MARK: Add Tag func
    private func addTagItem(tagTitle: String) {
        var tag: Tag = Tag()
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "title == %@", tagTitle as NSString)

        var foundTags: [Tag] = []
        do {
            foundTags = try moc.fetch(fetchRequest)
        } catch {
            // no-op
        }
        if !foundTags.isEmpty {
            if let firstTag = foundTags.first {
                tag = firstTag
            }
        } else {
            tag = Tag(using: moc)
            tag.id = UUID()
            tag.title = tagTitle
        }
        tags.append(tag)
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRecipeView(recipe: nil)
    }
}
//MARK: Add recipe func
func addNewRecipe (title: String, author: String, ingredients: String, text: String, newTags: [Tag], moc: NSManagedObjectContext) {
    let newRecipe = Recipe(using: moc)
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
//MARK: Edit recipe func
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
//MARK: Hides keyboard func
extension AddEditRecipeView {
    //hides keyboard
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
