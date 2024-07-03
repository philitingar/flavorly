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
    @Environment(\.customColorPalette) var customColorPalette
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var recipes: FetchedResults<Recipe>
    @State private var showingAddScreen = false
    @State private var showingSearchScreen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Apply background color
                themeManager.currentTheme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if recipes.isEmpty {
                        // Show the empty state message
                        Text("wellcome.message")
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .padding()
                    } else {
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
                                                    .foregroundColor(themeManager.currentTheme.textColor)
                                            }
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteRecipe)
                            .listRowBackground(themeManager.currentTheme.listBackgroundColor)
                        }
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Flavourly")
                        .font(.title)
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            withAnimation {
                                themeManager.currentTheme = lightOriginal
                            }
                        }) {
                            Label("Light Theme", systemImage: "sun.max.fill")
                        }
                        
                        Button(action: {
                            withAnimation {
                                themeManager.currentTheme = darkOriginal
                            }
                        }) {
                            Label("Dark Theme", systemImage: "moon.fill")
                        }
                        
                        Button(action: {
                            withAnimation {
                                // themeManager.currentTheme = colorfulTheme
                            }
                        }) {
                            Label("Colorful Theme", systemImage: "paintpalette.fill")
                        }
                    } label: {
                        Image(systemName: "rainbow")
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(.yellow, .orange, .pink)
                            .font(.headline)
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
        do {
            try moc.save()
        } catch let error as NSError {
            print("Error saving CoreData context: \(error), \(error.userInfo)")
            // Handle specific CoreData errors here
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var themeManager: ThemeManager
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
