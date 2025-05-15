//
//  DetailView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI
import CoreData

struct DetailView: View {
    @ObservedObject var recipe: Recipe  // Changed to ObservedObject for CoreData object
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                headerSection
                
                // Ingredients Card
                if let ingredients = recipe.ingredients, !ingredients.isEmpty {
                    cardView(title: "ingredient.list", content: ingredients, icon: "list.bullet")
                }
                
                // Instructions Card
                if let instructions = recipe.text, !instructions.isEmpty {
                    cardView(title: "instructions", content: instructions, icon: "text.book.closed")
                }
                
                // Tags Section
                if !recipe.tagArray.isEmpty {
                    tagsSection
                }
                recipeMetaSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    editButton
                    deleteButton
                }
            }
        }
        .alert(LocalizedStringKey("recipe.delete"), isPresented: $showingDeleteAlert) {
            Button(LocalizedStringKey("delete.button"), role: .destructive, action: deleteRecipe)
            Button(LocalizedStringKey("cancel.button"), role: .cancel) { }
        } message: {
            Text(LocalizedStringKey("delete.reassurance"))
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(recipe.title ?? "Untitled Recipe")
                .font(.headline.bold())
                .foregroundColor(.textBackgroundBlue)
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
            
            if let author = recipe.author, !author.isEmpty {
                    Text("By: \(author)")
                    .font(.caption)
                        .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
        .padding(.top, -10)
    }
    
    private func cardView(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.backgroundGreen)
                Text(LocalizedStringKey(title))
                    .font(.headline.bold())
                    .foregroundColor(.textBackgroundBlue)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.2))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey("tag"))
                .font(.headline.bold())
                .foregroundColor(.textBackgroundBlue)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recipe.tagArray, id: \.self) { tag in
                        Text(tag.title ?? "Untagged")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.backgroundGreen.opacity(0.2))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.backgroundGreen, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var recipeMetaSection: some View {
           Group {
               if recipe.timestamp != nil {
                   HStack {
                       VStack(alignment: .leading) {
                           Text(LocalizedStringKey("created"))
                               .font(.caption)
                               .foregroundColor(.secondary)
                           Text(recipe.timestamp!, style: .date)  // Using .date style for automatic formatting
                               .font(.caption)
                               .foregroundColor(.secondary)
                       }
                       Spacer()
                   }
                   .padding(.top, 20)
                   .transition(.opacity)  // Add animation if needed
               }
           }
       }
    
    private var editButton: some View {
        NavigationLink {
            AddEditRecipeView(recipe: recipe)
        } label: {
            Image(systemName: "pencil.circle")
                .symbolRenderingMode(.hierarchical)
                .font(.headline)
                .foregroundColor(.backgroundBlue)
        }
    }
    
    private var deleteButton: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            Image(systemName: "trash.circle")
                .symbolRenderingMode(.hierarchical)
                .font(.headline)
                .foregroundColor(.backgroundRed)
        }
    }
    
    // MARK: - Functions
    
    private func deleteRecipe() {
        moc.delete(recipe)
        try? moc.save()
        dismiss()
    }
}
