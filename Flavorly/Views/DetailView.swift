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
    @State private var showingDeleteAlert = false
    
    
    var body: some View {
        ScrollView {
            Text(recipe.title ?? "You have no recipes available")
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(Color.textBackgroundBlue)
                .bold()
            HStack {
                Text(LocalizedStringKey("By:"))
                    .font(.subheadline)
                Text(recipe.author ?? "You have not yet saved any recipe")
                    .lineLimit(2)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            Text(recipe.ingredients ?? "")
                .foregroundColor(.primary)
                .padding()
            
            Text(recipe.text ?? "")
                .foregroundColor(.primary)
                .padding()
            
            ForEach(recipe.tagArray) { tag in
                Text(tag.title ?? "")
                    .foregroundColor(.primary)
                    .padding()
            }
            
            HStack(alignment: .center) {
                
            }.padding(5)
            
                .navigationTitle(LocalizedStringKey("recipe.title"))
                .navigationBarTitleDisplayMode(.inline)
                .alert(LocalizedStringKey("recipe.delete"), isPresented: $showingDeleteAlert) {
                    Button(LocalizedStringKey("delete.button"), role: .destructive, action: deleteRecipe)
                    Button(LocalizedStringKey("cancel.button"), role: .cancel) { }
                } message: {
                    Text(LocalizedStringKey("delete.reassurance"))
                }
                .toolbar {
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .foregroundStyle(Color.backgroundRed)
                    }
                    NavigationLink {
                        AddEditRecipeView (recipe: recipe)
                    } label: {
                        Image(systemName: "pencil.tip.crop.circle.badge.plus.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.textBackgroundBlue, Color.backgroundGreen)
                    }
                }
        }
    }
    func deleteRecipe() {
        moc.delete(recipe)
        //comment this line if you want to make the deletion permanent
        try? moc.save()
        dismiss()
    }
}
