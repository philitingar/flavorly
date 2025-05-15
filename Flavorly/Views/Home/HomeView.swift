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
                                Label(LocalizedStringKey("no.recipes"), systemImage: "book.closed.fill")
                            } description: {
                                Text(LocalizedStringKey("add.first.recipe"))
                            }
                            .symbolEffect(.bounce, options: .repeating)
                        } else {
                            // Fallback on earlier versions
                        }
                    } else {
                        Text(LocalizedStringKey("no.recipes"))
                    }
                } else {
                    List {
                        ForEach(recipes) { recipe in
                            NavigationLink {
                                DetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                            
                        }
                        .onDelete(perform: deleteRecipe)
                        .listRowSeparatorTint(Color.backgroundBlue)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        .padding(4)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top)
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Flavourly")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.headline)
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
                    .foregroundColor(.backgroundBlue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title ?? "no.recipes")
                        .font(.headline)
                        .foregroundColor(.textBackgroundBlue)
                    
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
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
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

