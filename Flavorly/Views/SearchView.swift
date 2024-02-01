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
    
    @FetchRequest(sortDescriptors: [])
    private var tags: FetchedResults<Tag>
    
    @State private var multiSelection = Set<Tag>()
    @State private var isEditMode: EditMode = .active
    
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
                                .font(.title3)
                        }
                    }
                    if alignmentValue == 1 {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                
                            } label: {
                                Text("Search")
                            }
                        }
                    }
                }
            
            if alignmentValue == 0 {
                ZStack {
                    List{
                        ForEach(recipes, id: \.self) { recipe in
                            NavigationLink(destination: DetailView(recipe: recipe))
                            {
                                Text(recipe.title!)
                            }
                            
                        }.listRowBackground(Color.backgroundBlue.opacity(0.4))
                    }
                    .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt.title"))
                    .onChange(of: searchText, perform: { newValue in
                        recipes.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                    })
                }
            } else {
                
                VStack {
                    Section {
                        List(selection: $multiSelection) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag.title!)
                                
                            }.listRowBackground(Color.backgroundGreen.opacity(0.4))
                        }
                        .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt.tag"))
                        .onChange(of: searchText, perform: { newValue in
                            tags.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                        })
                        .environment(\.editMode, self.$isEditMode)
                    } header: {
                        Text("Select tags to search")
                        
                    }
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
