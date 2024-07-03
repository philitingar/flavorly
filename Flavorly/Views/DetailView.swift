//
//  DetailView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import CoreData
import SwiftUI

struct DetailView: View {
    @State var recipe: Recipe
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.customColorPalette) var customColorPalette
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                Text(recipe.title ?? "no.recipes")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .foregroundColor(themeManager.currentTheme.searchIconColor)
                    .bold()
                HStack {
                    Text(LocalizedStringKey("By:"))
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Text(recipe.author ?? "no.recipe.saved")
                        .lineLimit(2)
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
                Text(recipe.ingredients ?? "")
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding()
                Text(recipe.text ?? "")
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding()
                
                VStack {
                    if recipe.tagArray == [] {
                        
                    } else {
                        Text("tags.in.recipe")
                            .padding()
                            .font(.title3)
                            .bold()
                            .foregroundColor(themeManager.currentTheme.addIconColor)
                            .multilineTextAlignment(.center)
                    }
                    HStack {
                        Text(
                            recipe.tagArray
                                .map({ tag in
                                    tag.title!
                                })
                                .joined(separator:", ")
                        )
                        .buttonStyle(.bordered)
                        .tint(themeManager.currentTheme.textColor)
                        .foregroundColor(themeManager.currentTheme.textColor)
                        .padding(10)
                    }
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(LocalizedStringKey("recipe.title"))
                            .font(.title2)
                            .foregroundColor(themeManager.currentTheme.textColor)
                    }
                }
                .alert(LocalizedStringKey("recipe.delete"), isPresented: $showingDeleteAlert) {
                    Button(LocalizedStringKey("delete.button"), role: .destructive, action: deleteRecipe)
                    Button(LocalizedStringKey("cancel.button"), role: .cancel) { }
                } message: {
                    Text(LocalizedStringKey("delete.reassurance"))
                }
                //MARK: Toolbars
                .toolbar {
                    NavigationLink {
                        AddEditRecipeView (recipe: recipe)
                    } label: {
                        Image(systemName: "pencil.tip.crop.circle.badge.plus.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(themeManager.currentTheme.searchIconColor, themeManager.currentTheme.addIconColor)
                            .font(.title3)
                    }
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .foregroundStyle(themeManager.currentTheme.deleteIconColor)
                            .font(.title3)
                    }
                }
            }
        }
    }
    //MARK: func deleteRecipe
    func deleteRecipe() {
        moc.delete(recipe)
        //comment this line if you want to make the deletion permanent
        do {
            try moc.save()
        } catch let error as NSError {
            print("Error saving CoreData context: \(error), \(error.userInfo)")
            // Handle specific CoreData errors here
        }
        dismiss()
    }
}
