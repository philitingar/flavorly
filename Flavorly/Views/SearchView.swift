//
//  SearchView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import CoreData
import SwiftUI

struct SearchView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [])
    private var recipes: FetchedResults<Recipe>
    let recipe: Recipe?
    @State private var searchText = ""
    //Segment value for picker
    @State var alignmentValue: Int = 1
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $alignmentValue) {
                    Text("By name")
                        .tag(0)
                    Text("By tag")
                        .tag(1)
                }.pickerStyle(.segmented)
                    .padding(.bottom, 15)
            } .navigationTitle(LocalizedStringKey("recipe.search"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                                .foregroundStyle(Color.backgroundRed)
                        }
                    }
                }
            
            if alignmentValue == 0 {
                ZStack {
                    List {
                        ForEach(recipes, id: \.self) { recipe in
                            NavigationLink(destination: DetailView(recipe: recipe))
                            {
                                Text(recipe.title!)
                            }
                            
                        }.listRowBackground(Color.backgroundBeige)
                    }
                    .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt"))
                    .onChange(of: searchText, perform: { newValue in
                        recipes.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                    })
                }
            } else {
                ZStack {
                    List {
                        ForEach(recipe?.tagArray ?? [], id: \.self) { tag in
                            NavigationLink(destination: DetailView(recipe: recipe!))
                            {
                                Text(tag.title!)
                            }
                            
                        }.listRowBackground(Color.backgroundBeige)
                    }
                    .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt"))
                    .onChange(of: searchText, perform: { newValue in
                        recipes.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                    })
                    
                }
            }
        }
       
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(recipe: nil)
    }
}
