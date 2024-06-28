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
    @State private var showingDeleteAlert = false
    
    var body: some View {
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
                Text(recipe.author ?? "no.recipe.saved")
                    .lineLimit(2)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.secondaryColor)
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
                    .tint(.primary)
                    .foregroundColor(.primary)
                    .padding(10)
                }
            }
            .navigationTitle(LocalizedStringKey("recipe.title"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(LocalizedStringKey("recipe.delete"), isPresented: $showingDeleteAlert) {
                Button(LocalizedStringKey("delete.button"), role: .destructive, action: deleteRecipe)
                Button(LocalizedStringKey("cancel.button"), role: .cancel) { }
            } message: {
                Text(LocalizedStringKey("delete.reassurance"))
            }
            //MARK: Toolbars
            .toolbar {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundStyle(themeManager.currentTheme.deleteIconColor)
                        .font(.title3)
                }
                NavigationLink {
                    AddEditRecipeView (recipe: recipe)
                } label: {
                    Image(systemName: "pencil.tip.crop.circle.badge.plus.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(themeManager.currentTheme.searchIconColor, themeManager.currentTheme.addIconColor)
                        .font(.title3)
                }
            }
        }
    }
    //MARK: func deleteRecipe
    func deleteRecipe() {
        moc.delete(recipe)
        //comment this line if you want to make the deletion permanent
        try? moc.save()
        dismiss()
    }
}
