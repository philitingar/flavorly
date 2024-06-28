//
//  ContentView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var themeManager: ThemeManager
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
                                Text(recipe.title ?? "no.recipes")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.titleColor)
                                HStack {
                                    Text(LocalizedStringKey ("By:"))
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.currentTheme.textColor)
                                    Text(recipe.author ?? "unknown.author")
                                        .foregroundColor(themeManager.currentTheme.secondaryColor)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteRecipe)
                .listRowBackground(themeManager.currentTheme.listBackgroundColor)
            }
            .overlay(Group {
                if recipes.isEmpty {
                    Text("wellcome.message").padding(5)
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
            })
            .navigationTitle("Flavourly")
            .toolbar {
                //MARK: Toolbar items
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        self.showingAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(themeManager.currentTheme.addIconColor)
                            .font(.title3)
                    }
                    .accessibilityIdentifier("recipe.add")
                    Button {
                        self.showingSearchScreen.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundStyle(themeManager.currentTheme.searchIconColor)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddEditRecipeView(recipe: nil)
            }
            .sheet(isPresented: $showingSearchScreen) {
                SearchView(tag: Tag(), recipe: nil)
            }
        }.frame(maxWidth: .infinity)
            .navigationViewStyle(.stack)
    }
    //MARK: func DeleteRecipe
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
        ZStack {
            ContentView()
        }
    }
}
