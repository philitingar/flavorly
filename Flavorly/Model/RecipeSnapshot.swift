//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 14/5/25.
//
import SwiftUI
struct RecipeSnapshot: Codable {
    let title: String?
    let author: String?
    let ingredients: String?
    let text: String?
    let timestamp: Date?
    let tags: [TagSnapshot]?
    
    init(from recipe: Recipe) {
        self.title = recipe.title
        self.author = recipe.author
        self.ingredients = recipe.ingredients
        self.text = recipe.text
        self.timestamp = recipe.timestamp
        self.tags = recipe.tagArray.map { TagSnapshot(from: $0) }
    }
}

struct TagSnapshot: Codable {
    let id: UUID?
    let title: String?
    
    init(from tag: Tag) {
        self.id = tag.id
        self.title = tag.title
    }
}
