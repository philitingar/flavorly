//
//  RecipePDFView.swift
//  Flavourly
//
//  Created by Timea Bartha on 12/8/25.
//

import SwiftUI
import CoreData

struct RecipePDFView: View {
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text(recipe.title ?? "Untitled Recipe")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            
            if let author = recipe.author, !author.isEmpty {
                Text("By: \(author)")
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 20)
            }
            
            // Ingredients
            if let ingredients = recipe.ingredients, !ingredients.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 4)
                    
                    ForEach(ingredients.components(separatedBy: "\n"), id: \.self) { ingredient in
                        Text("• \(ingredient)")
                            .font(.system(size: 14))
                    }
                }
                .padding(.bottom, 20)
            }
            
            // Instructions
            if let instructions = recipe.text, !instructions.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 4)
                    
                    Text(instructions)
                        .font(.system(size: 14))
                }
            }
            // Footer
            if let timestamp = recipe.timestamp {
                Text("Created: \(timestamp.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 40)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
