//
//  SearchView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI
import CoreData

struct SearchView: View {
    @State var tag: Tag?
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingDeleteAlert = false
    @FetchRequest(sortDescriptors: []) private var recipes: FetchedResults<Recipe>
    @FetchRequest(sortDescriptors: []) private var tags: FetchedResults<Tag>
    @State private var multiSelection = Set<Tag>()
    @State private var isEditMode: EditMode = .active
    let recipe: Recipe?
    @State private var searchText = ""
    @State private var showingRecipeListScreen = false
    @State var alignmentValue: Int = 1
    
    var body: some View {
        
            NavigationStack {
                ZStack {
                    themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
                VStack {
                    // Segmented Picker
                    Picker("", selection: $alignmentValue) {
                        Text("pick.by.name").tag(0)
                        Text("pick.by.tag").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 15)
                    
                    // Main Content
                    if alignmentValue == 0 {
                        recipeListView
                    } else {
                        tagListView
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if alignmentValue == 1 {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            deleteButton
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            searchButton
                        }
                        ToolbarItem(placement: .principal) {
                            Text("recipe.search")
                                .font(.title2)
                                .bold()
                                .foregroundColor(themeManager.currentTheme.viewTitleColor)
                        }
                    }
                }
                .sheet(isPresented: $showingRecipeListScreen) {
                    RecipeListView(tags: multiSelection)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var recipeListView: some View {
        Group {
            if recipes.isEmpty {
                if #available(iOS 17.0, *) {
                    if #available(iOS 18.0, *) {
                        ContentUnavailableView {
                            Label {
                                Text(LocalizedStringKey("no.recipe.found"))
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                            } icon: {
                                Image(systemName: "book.pages")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                            }
                        } description: {
                            Text(LocalizedStringKey("try.diff.search"))
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        }
                        .symbolEffect(.wiggle, options: .repeating)
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    // Fallback on earlier versions
                }
            } else {
                List {
                    ForEach(recipes, id: \.self) { recipe in
                        NavigationLink(destination: DetailView(recipe: recipe)) {
                            Text(recipe.title ?? "Untitled Recipe")
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        }
                    }
                    .listRowSeparatorTint(themeManager.currentTheme.dividerColor)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                    .padding(4)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "search.prompt.title")
                .onChange(of: searchText) { newValue in
                    recipes.nsPredicate = newValue.isEmpty ? nil :
                    NSPredicate(format: "title CONTAINS[c] %@", newValue)
                }
                .padding()
            }
        }
    }
    
    private var tagListView: some View {
        Group {
            if tags.isEmpty {
                if #available(iOS 17.0, *) {
                    if #available(iOS 18.0, *) {
                        ContentUnavailableView {
                            
                            Label {
                                Text(LocalizedStringKey("no.tag.found"))
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.primaryTextColor)
                            } icon: {
                                Image(systemName: "tag")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(themeManager.currentTheme.searchButtonColor)
                            }
                            
                        } description: {
                            Text(LocalizedStringKey("create.tag.organise"))
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        }
                        .symbolEffect(.wiggle, options: .repeating)
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    // Fallback on earlier versions
                }
            } else {
                List(selection: $multiSelection) {
                    Section("select.tags") {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.title ?? "Untitled Tag")
                                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(themeManager.currentTheme.dividerColor)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                    .padding(4)
                }
                .accentColor(themeManager.currentTheme.accentColor)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "search.prompt.tag")
                .onChange(of: searchText) { newValue in
                    tags.nsPredicate = newValue.isEmpty ? nil :
                    NSPredicate(format: "title CONTAINS[c] %@", newValue)
                }
                .environment(\.editMode, $isEditMode)
                .alert("warning.alert", isPresented: $showingDeleteAlert) {
                    Button("delete.button", role: .destructive, action: deleteTags)
                    Button("cancel.button", role: .cancel) { }
                } message: {
                    Text("delete.tag.warning.text")
                }
            }
        }
    }
    
    private var deleteButton: some View {
        Button {
            deletePrompt()
        } label: {
            Image(systemName: "trash.circle")
                .font(.title2)
                .foregroundColor(themeManager.currentTheme.deleteButtonColor)
        }
    }
    
    private var searchButton: some View {
        Button {
            showingRecipeListScreen.toggle()
        } label: {
            Image(systemName: "magnifyingglass.circle")
                .font(.title2)
                .foregroundColor(themeManager.currentTheme.searchButtonColor)
        }
    }
    
    // MARK: - Functions
    
    func deleteTags() {
        for tag in multiSelection {
            moc.delete(tag)
        }
        try? moc.save()
    }
    
    func deletePrompt() {
        showingDeleteAlert = true
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tag: Tag(), recipe: nil)
    }
}
