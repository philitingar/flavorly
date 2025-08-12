//
//  RecipePDFView.swift
//  Flavourly
//
//  Created by Timea Bartha on 12/8/25.
//
import SwiftUI
import PDFKit
import CoreData

// MARK: - Main PDF Content View
struct RecipePDFContentView: View {
    let recipe: Recipe
    let availableHeight: CGFloat

    // Define margins and footer height - match them with PDF generation constants
    let topMargin: CGFloat = 40
    let bottomMargin: CGFloat = 40
    let footerHeight: CGFloat = 60

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            RecipePDFHeaderView(recipe: recipe)
            // Ingredients Section
            if let ingredients = recipe.ingredients, !ingredients.isEmpty {
                RecipePDFIngredientsView(ingredients: ingredients)
            }
            // Instructions Section
            if let instructions = recipe.text, !instructions.isEmpty {
                RecipePDFInstructionsView(instructions: instructions)
            }
        }
        .padding(.top, topMargin) // Add explicit top padding
        .padding(.bottom, bottomMargin + footerHeight) // Add bottom padding including footer space
        .padding(.horizontal, 40) // Keep horizontal padding consistent
        .frame(width: 595.2, alignment: .topLeading)
    }
}

// MARK: - Header View
struct RecipePDFHeaderView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Recipe Title
            Text(recipe.title ?? "Untitled Recipe")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            // Author row
            if let author = recipe.author, !author.isEmpty {
                HStack {
                    Label(author, systemImage: "person.circle")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
}

// MARK: - Ingredients View
struct RecipePDFIngredientsView: View {
    let ingredients: String
    
    var ingredientsList: [String] {
        ingredients.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section Header
            HStack {
                Image(systemName: "list.bullet.rectangle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.green)
                
                Text("Ingredients")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            
            // Ingredients List
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(ingredientsList.enumerated()), id: \.offset) { index, ingredient in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                        
                        Text(ingredient)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

// MARK: - Instructions View
struct RecipePDFInstructionsView: View {
    let instructions: String
    
    var instructionSteps: [String] {
        let steps = instructions.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        // If it's one big block with periods, try to split it
        if steps.count == 1, let firstStep = steps.first, firstStep.contains(". ") {
            return firstStep.components(separatedBy: ". ")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        }
        
        return steps
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section Header
            HStack {
                Image(systemName: "list.number")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.blue)
                
                Text("Instructions")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            
            // Instructions List
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(instructionSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 15) {
                        Text("\(index + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color.blue))
                        
                        Text(step)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

// MARK: - Footer View
struct RecipePDFFooterView: View {
    let pageNumber: Int
    let totalPages: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 40)
            
            HStack {
                if let qrImage = UIImage(named: "qr-flavourly") {
                    Image(uiImage: qrImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                Text("Created with Flavourly")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Page \(pageNumber) of \(totalPages)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
        }
        .background(Color.white)
    }
}
