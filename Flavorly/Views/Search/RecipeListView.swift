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
            VStack(alignment: .center) {
                Text("Here are the recipes matching your selected tags:")
                    .font(.headline)
                    .padding(2)
                List {
                    ForEach(recipes, id: \.self) { recipe in
                        NavigationLink(destination: DetailView(recipe: recipe))
                        {
                            Text(recipe.title!)
                        }
                    }
                    .listRowSeparatorTint(Color.backgroundBlue)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                    .padding(4)
                }
                .padding(.horizontal)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                .onAppear {
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
                .overlay(Group {
                    if recipes.isEmpty {
                        if #available(iOS 17.0, *) {
                            if #available(iOS 18.0, *) {
                                ContentUnavailableView {
                                    Label {
                                        Text("no.recipe.to.tag.message")
                                            .font(.headline)
                                    } icon: {
                                        Image(systemName: "book.pages")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                    }
                                    
                                } description: {
                                    Text("")
                                }
                                .symbolEffect(.bounce, options: .repeating)
                                
                            } else {
                                Text("no.recipe.to.tag.message").padding(5)
                            }
                        }
                    }
                }
                )
            }
            .padding(2)
        }
    }
}

