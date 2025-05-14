//
//  ContentView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.title),
            SortDescriptor(\.author)
        ]
    ) var recipes: FetchedResults<Recipe>
    
    @State private var showingAddScreen = false
    @State private var showingSearchScreen = false
    
    var body: some View {
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    if #available(iOS 17.0, *) {
                        if #available(iOS 18.0, *) {
                            ContentUnavailableView {
                                Label {
                                    Text("No Recipes Yet")
                                } icon: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            } description: {
                                Text("Add your first recipe to get started")
                                    .foregroundColor(.secondary)
                            }
                            .symbolEffect(.bounce, options: .repeating)
                        } else {
                            // Fallback on earlier versions
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    List {
                        ForEach(recipes) { recipe in
                            NavigationLink {
                                DetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                            .listRowBackground(Color(.secondarySystemGroupedBackground))
                        }
                        .onDelete(perform: deleteRecipe)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Flavourly")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // Explicit toolbar content builder
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddEditRecipeView(recipe: nil)
            }
        }
        
    }
    
    private struct RecipeRow: View {
        let recipe: Recipe
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: "book.closed.fill")
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title ?? "no.recipes")
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Text("By:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(recipe.author ?? "unknown.author")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    func deleteRecipe(at offsets: IndexSet) {
        for offset in offsets {
            let recipe = recipes[offset]
            moc.delete(recipe)
        }
        try? moc.save()
    }
}
//MARK: Extension custom color
extension Color {
    static let backgroundBeige = Color("BackgroundBeige")
    static let backgroundGreen = Color("ButtonBackgroundGreen")
    static let backgroundRed = Color("BackgroundColorRed")
    static let backgroundBlue = Color("ButtonBackgroundBlue")
    static let textBackgroundBlue = Color("TextBackgroundBlue")
}

