//
//  SearchView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import CoreData
import SwiftUI

struct SearchView: View {
    @State var tag: Tag
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    @FetchRequest(sortDescriptors: [])
    private var recipes: FetchedResults<Recipe>
    
    @FetchRequest(sortDescriptors: [])
    private var tags: FetchedResults<Tag>
    
    @State private var multiSelection = Set<Tag>()
    @State private var isEditMode: EditMode = .active
    
    let recipe: Recipe?
    @State private var searchText = ""
    @State private var showingRecipeListScreen = false
    //Segment value for picker
    @State var alignmentValue: Int = 1
    
    @State var deletableTagIndexes: IndexSet
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $alignmentValue) {
                    Text("pick.by.name")
                        .tag(0)
                    Text("pick.by.tag")
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
                                self.showingRecipeListScreen.toggle()
                            } label: {
                                Image(systemName: "hand.point.up.left.and.text.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.textBackgroundBlue, Color.backgroundGreen)
                                    .font(.title3)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingRecipeListScreen) {
                    RecipeListView(tags: multiSelection)
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
                    .overlay(Group {
                        if recipes.isEmpty {
                            Text("no.recipe.saved").padding(5)
                        }
                    })
                }
            } else {
                Section {
                    List(selection: $multiSelection) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.title!)
                        }
                        .onDelete(perform: deletePrompt)
                        .listRowBackground(Color.backgroundGreen.opacity(0.4))
                        .alert(LocalizedStringKey("WARNING!"), isPresented: $showingDeleteAlert) {
                            Button(LocalizedStringKey("delete.button"), role: .destructive, action: deleteTags)
                            Button(LocalizedStringKey("cancel.button"), role: .cancel) { }
                        } message: {
                            Text(LocalizedStringKey("If you delete this tag, it will be removed from all the recipes. None of your recipes will have this tag anymore!"))
                        }

                    }
                    .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt.tag"))
                    .onChange(of: searchText, perform: { newValue in
                        tags.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                    })
                    .environment(\.editMode, self.$isEditMode)
                    .overlay(Group {
                        if tags.isEmpty {
                            Text("no.tags.saved").padding(5)
                        }
                    })
                } header: {
                    Text("select.tags")
                }
            }
        }
    }
    func deleteTags() {
        for offset in deletableTagIndexes {
            // find this book in our fetch request
            let tag = tags[offset]
            // delete it from the context
            moc.delete(tag)
        }
        // save the context
        try? moc.save()
        
        deletableTagIndexes = IndexSet()
    }
    func deletePrompt(at offsets: IndexSet) {
        showingDeleteAlert = true
        deletableTagIndexes = offsets
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tag: Tag(), recipe: nil, deletableTagIndexes: IndexSet())
    }
}
