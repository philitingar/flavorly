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
            Text(recipe.author ?? "Unknown author")
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
            
            HardnessView(hardness: .constant(Int(recipe.hardness)))
                .font(.caption)
            
                .navigationTitle(recipe.title?.uppercased() ?? "Unknown Recipe")
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
                        Label("Delete this recipe", systemImage: "trash")
                    }
                    NavigationLink("Edit") {
                        AddEditRecipeView (recipe: recipe)
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
