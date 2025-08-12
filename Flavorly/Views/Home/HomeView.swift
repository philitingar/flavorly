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
    @EnvironmentObject var themeManager: ThemeManager
    
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
                ZStack {
                themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
                Group {
                    if recipes.isEmpty {
                        if #available(iOS 17.0, *) {
                            if #available(iOS 18.0, *) {
                                ContentUnavailableView {
                                    Label { Text(LocalizedStringKey("no.recipes"))
                                            .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                    } icon: {
                                        Image(systemName: "book.closed.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(themeManager.currentTheme.addButtonColor)
                                    }
                                } description: {
                                    Text(LocalizedStringKey("add.first.recipe"))
                                        .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                }
                                .symbolEffect(.bounce, options: .repeating)
                            } else {
                                // Fallback on earlier versions
                            }
                        } else {
                            Text(LocalizedStringKey("no.recipes"))
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        }
                    } else {
                        List {
                            ForEach(recipes) { recipe in
                                NavigationLink {
                                    DetailView(recipe: recipe)
                                } label: {
                                    RecipeRow(recipe: recipe)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteRecipe)
                            .listRowSeparatorTint(themeManager.currentTheme.dividerColor)
                            .tint(themeManager.currentTheme.appBackgroundColor)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                            .padding(4)
                        }
                        .scrollContentBackground(.hidden)
                        .padding(.top)
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.title3)
                                .foregroundColor(themeManager.currentTheme.searchButtonColor)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Flavourly")
                            .font(.title2)
                            .bold()
                            .foregroundColor(themeManager.currentTheme.viewTitleColor)
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddEditRecipeView(recipe: nil)
                }
            }
        }
    }
    
    private struct RecipeRow: View {
        let recipe: Recipe
        @EnvironmentObject var themeManager: ThemeManager

        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: "book.closed.fill")
                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title ?? "no.recipes")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.primaryTextColor)
                    
                    HStack(spacing: 4) {
                        Text("By:")
                            .font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                        Text(recipe.author ?? "unknown.author")
                            .font(.subheadline)
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
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

