//
//  RecipeListView.swift
//  Flavorly
//
//  Created by Timea Bartha on 1/2/24.
//

import SwiftUI

struct RecipeListView: View {
    @FetchRequest(sortDescriptors: [])
    private var recipes: FetchedResults<Recipe>

    @State var tags: Set<Tag>

    var body: some View {
        List{
            ForEach(recipes, id: \.self) { recipe in
                NavigationLink(destination: DetailView(recipe: recipe))
                {
                    Text(recipe.title!)
                }
                
            }.listRowBackground(Color.backgroundBlue.opacity(0.4))
        }
    }
}

