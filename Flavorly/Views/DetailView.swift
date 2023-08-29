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
                .foregroundColor(.secondary)
            Text(recipe.author ?? "Unknown author")
                .lineLimit(2)
                .font(.headline)
                .foregroundColor(.secondary)
            HStack(alignment: .center) {
                Text(recipe.type?.uppercased() ?? "SOUP")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
                Text(recipe.occasion?.uppercased() ?? "Unknown occasion")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
                Text(recipe.diet?.uppercased() ?? "Unknown diet")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
                Text(recipe.ingredients ?? "Unknown ingredients")
                    .foregroundColor(.secondary)
                    .padding()
                
                Text(recipe.text ?? "No recipe text")
                    .foregroundColor(.secondary)
                    .padding()
            
                .navigationTitle("Recipe")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Delete recipe", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive, action: deleteRecipe)
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure?")
                }
                .toolbar {
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete this recipe", systemImage: "trash.circle.fill")
                            .foregroundStyle(.orange)
                    }
                    NavigationLink {
                        AddEditRecipeView (recipe: recipe)
                    } label: {
                        Label("Edit this recipe", systemImage: "square.and.pencil.circle.fill")
                            .foregroundStyle(.orange)
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
