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
    @EnvironmentObject var themeManager: ThemeManager
    
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
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
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(recipe.title ?? "Untitled Recipe")
                .font(.headline.bold())
                .foregroundColor(themeManager.currentTheme.viewTitleColor)
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
            
            if let author = recipe.author, !author.isEmpty {
                Text("By: \(author)")
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.secondaryTextColor)
            }
        }
        .padding(.vertical, 5)
        .padding(.top, -10)
    }
    
    private func cardView(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                Text(LocalizedStringKey(title))
                    .font(.headline.bold())
                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.currentTheme.textFieldBackgroundColor)
                .shadow(color: themeManager.currentTheme.primaryTextColor.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey("tag"))
                .font(.headline.bold())
                .foregroundColor(themeManager.currentTheme.primaryTextColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recipe.tagArray, id: \.self) { tag in
                        Text(tag.title ?? "Untagged")
                            .font(.caption)
                            .foregroundColor(themeManager.currentTheme.primaryTextColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(themeManager.currentTheme.addButtonColor.opacity(0.2))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(themeManager.currentTheme.addButtonColor, lineWidth: 1)
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
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                        Text(recipe.timestamp!, style: .date)  // Using .date style for automatic formatting
                            .font(.caption)
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
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
                .foregroundColor(themeManager.currentTheme.addButtonColor)
        }
    }
    
    private var deleteButton: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            Image(systemName: "trash.circle")
                .symbolRenderingMode(.hierarchical)
                .font(.headline)
                .foregroundColor(themeManager.currentTheme.deleteButtonColor)
        }
    }
    
    // MARK: - Functions
    
    private func deleteRecipe() {
        moc.delete(recipe)
        try? moc.save()
        dismiss()
    }
}
