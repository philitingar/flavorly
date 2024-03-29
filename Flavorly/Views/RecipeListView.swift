//
//  RecipeListView.swift
//  Flavorly
//
//  Created by Timea Bartha on 1/2/24.
//

import SwiftUI
import CoreData


struct RecipeListView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var recipes: [Recipe] = []
    @State var tags: Set<Tag>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes, id: \.self) { recipe in
                    NavigationLink(destination: DetailView(recipe: recipe))
                    {
                        Text(recipe.title!)
                    }
                }.listRowBackground(Color.backgroundBlue.opacity(0.4))
            }.onAppear {
                let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
                var tagPredicates = [NSPredicate]()
                tags.forEach { tag in
                    let tagPredicate = NSPredicate(format: "ANY recipeToTag.id == %@", tag.id! as NSUUID)
                    tagPredicates.append(tagPredicate)
                }
                let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: tagPredicates)
                fetchRequest.predicate = compoundPredicate
                do {
                    recipes = try moc.fetch(fetchRequest)
                } catch {
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                            .foregroundStyle(Color.backgroundRed)
                            .font(.title3)
                    }
                }
            }
            .overlay(Group {
                if recipes.isEmpty {
                    Text("no.recipe.to.tag.message").padding(5)
                }
            })
        }
    }
}

