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
                                HStack {
                                    Text("By:")
                                        .font(.subheadline)
                                    Text(recipe.author ?? "Unknown Author")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteRecipe)
                .listRowBackground(Color.backgroundBeige)
            }
            
                .navigationTitle("Flavorly")
                .toolbar {
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            self.showingAddScreen.toggle()
                        } label: {
                            Label("Add Recipe", systemImage: "plus.circle.fill")
                        }
                        
                        
                        Button {
                            self.showingSearchScreen.toggle()
                        } label: {
                            Label("Search", systemImage: "magnifyingglass.circle.fill")
                                .foregroundStyle(Color.textBackgroundBlue)
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddEditRecipeView(recipe: nil)
                }
                .sheet(isPresented: $showingSearchScreen) {
                    SearchView()
                }
        }.frame(maxWidth: .infinity)
            
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
extension Color {
    static let backgroundBeige = Color("BackgroundBeige")
    static let backgroundGreen = Color("ButtonBackgroundGreen")
    static let backgroundRed = Color("BackgroundColorRed")
    static let backgroundBlue = Color("ButtonBackgroundBlue")
    static let textBackgroundBlue = Color("TextBackgroundBlue")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
