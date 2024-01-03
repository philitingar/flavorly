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
            Text(recipe.title ?? "Unknown Recipe")
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(Color.textBackgroundBlue)
                .bold()
            HStack {
                Text(LocalizedStringKey("By:"))
                    .font(.subheadline)
                Text(recipe.author ?? "Unknown author")
                    .lineLimit(2)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .center) {
                Text(NSLocalizedString(recipe.type!, comment: ""))
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.primary)
                    .background(Color.backgroundBlue)
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
                Text(NSLocalizedString(recipe.occasion!, comment: ""))
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.primary)
                    .background(Color.backgroundBlue)
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
                Text(NSLocalizedString(recipe.diet!, comment: ""))
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.primary)
                    .background(Color.backgroundBlue)
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }.padding(5)
            Text(recipe.ingredients ?? "Unknown ingredients")
                .foregroundColor(.primary)
                .padding()
            
            Text(recipe.text ?? "No recipe text")
                .foregroundColor(.primary)
                .padding()
            
                .navigationTitle(LocalizedStringKey("Recipe"))
                .navigationBarTitleDisplayMode(.inline)
                .alert(LocalizedStringKey("recipe.delete"), isPresented: $showingDeleteAlert) {
                    Button(LocalizedStringKey("Delete"), role: .destructive, action: deleteRecipe)
                    Button(LocalizedStringKey("Cancel"), role: .cancel) { }
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
