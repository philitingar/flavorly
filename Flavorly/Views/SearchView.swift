//
//  SearchView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import CoreData
import SwiftUI

struct SearchView: View {
    @State var tag: Tag?
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
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
    
    var body: some View {
        NavigationStack {
            VStack {
                //MARK: Picker
                Picker("", selection: $alignmentValue) {
                    Text("pick.by.name")
                        .tag(0)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    Text("pick.by.tag")
                        .tag(1)
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 15)
                .background(themeManager.currentTheme.backgroundColor)
                .foregroundColor(.white)
            }
            .preferredColorScheme(themeManager.currentTheme.preferredColorScheme)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(LocalizedStringKey("recipe.search"))
                        .font(.title)
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        //MARK: Toolbar Items
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                                .foregroundStyle(themeManager.currentTheme.deleteIconColor)
                                .font(.title3)
                        }
                    }
                    if alignmentValue == 1 {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                deletePrompt()
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundStyle(themeManager.currentTheme.deleteIconColor)
                                    .font(.title3)
                            }
                            Button {
                                self.showingRecipeListScreen.toggle()
                            } label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .foregroundStyle(themeManager.currentTheme.searchIconColor)
                                    .font(.title3)
                            }
                            
                        }
                    }
                }
                .sheet(isPresented: $showingRecipeListScreen) {
                    RecipeListView(tags: multiSelection)
                }
            if alignmentValue == 0 {
                //MARK: Recipe List
                ZStack {
                    themeManager.currentTheme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    List {
                        ForEach(recipes, id: \.self) { recipe in
                            NavigationLink(destination: DetailView(recipe: recipe))
                            {
                                Text(recipe.title!)
                                    .foregroundColor(themeManager.currentTheme.textColor)
                            }
                        }.listRowBackground(themeManager.currentTheme.listBackgroundColor)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt.title"))
                    .onChange(of: searchText, perform: { newValue in
                        recipes.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                    })
                    .overlay(Group {
                        if recipes.isEmpty {
                            Text("no.recipe.saved").padding(5)
                                .foregroundColor(themeManager.currentTheme.textColor)
                        }
                    })
                }
                .preferredColorScheme(themeManager.currentTheme.preferredColorScheme)
            } else {
                //MARK: Tag List
                Section {
                    ZStack {
                        themeManager.currentTheme.backgroundColor
                            .edgesIgnoringSafeArea(.all)
                        List(selection: $multiSelection) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag.title!)
                                    .foregroundColor(themeManager.currentTheme.textColor)
                            }
                            .listRowBackground(themeManager.currentTheme.listBackgroundColor)
                            .alert(LocalizedStringKey("warning.alert"), isPresented: $showingDeleteAlert) {
                                Button(LocalizedStringKey("delete.button"), role: .destructive, action: deleteTags)
                                Button(LocalizedStringKey("cancel.button"), role: .cancel) { }
                            } message: {
                                Text(LocalizedStringKey("delete.tag.warning.text"))
                            }
                        }
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                        .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: LocalizedStringKey("search.prompt.tag"))
                        .onChange(of: searchText, perform: { newValue in
                            tags.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[c] %@", newValue)
                        })
                        .environment(\.editMode, self.$isEditMode)
                        .overlay(Group {
                            if tags.isEmpty {
                                Text("no.tags.saved").padding(5)
                                    .foregroundColor(themeManager.currentTheme.textColor)
                            }
                        })
                    }
                    .preferredColorScheme(themeManager.currentTheme.preferredColorScheme)
                } header: {
                    Text("select.tags")
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
            }
        }
    }
    //MARK: Delete Tags Function
    func deleteTags() {
        for tag in multiSelection {
            // delete it from the context
            moc.delete(tag)
        }
        // save the context
        try? moc.save()
    }
    func deletePrompt() {
        showingDeleteAlert = true
    }
}

struct SearchView_Previews: PreviewProvider {
    @EnvironmentObject var themeManager: ThemeManager
    static var previews: some View {
        SearchView(tag: Tag(), recipe: nil)
    }
}
