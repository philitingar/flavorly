//
//  ContentView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var recipes: FetchedResults<Recipe>
    
    @State private var showingAddScreen = false
    @State private var showingSearchScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        DetailView(recipe: recipe)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(recipe.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(recipe.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteRecipe)
            }
                .navigationTitle("Flavorly")
                .toolbar {
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            self.showingAddScreen.toggle()
                        } label: {
                            Label("Add Recipe", systemImage: "plus.circle.fill")
                                .foregroundStyle(.orange)
                        }
                        Button {
                            self.showingSearchScreen.toggle()
                        } label: {
                            Label("Search", systemImage: "magnifyingglass.circle.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddEditRecipeView(recipe: nil)
                }
                .sheet(isPresented: $showingSearchScreen) {
                    SearchView()
                }
        }
    }
    func deleteRecipe(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let recipe = recipes[offset]

            // delete it from the context
            moc.delete(recipe)
        }

        // save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
