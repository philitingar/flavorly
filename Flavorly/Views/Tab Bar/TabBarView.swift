//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 14/5/25.
//

import SwiftUI
import CoreData

struct TabBarView: View {
    @State private var selectedTab: Tab = .home
    @State private var isTabBarHidden: Bool = false
    @State private var settingsNavigationPath = NavigationPath()
    
    let cornerRadius: CGFloat = 60
    let iconSize: CGFloat = 30
    let horizontalPadding: CGFloat = 20
    let tabBarBottomPadding: CGFloat = 20
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                    .environment(\.managedObjectContext, viewContext)
                
                SearchView(tag: Tag(), recipe: nil)
                    .tag(Tab.search)
                    .environment(\.managedObjectContext, viewContext)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            .toolbar(.hidden, for: .tabBar)
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        Spacer()
                        Button {
                            if selectedTab == tab && tab == .settings {
                                settingsNavigationPath = NavigationPath()
                            }
                            selectedTab = tab
                        } label: {
                            VStack {
                                Image(systemName: tab.image)
                                    .font(.system(size: 25))
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                
                                Text(tab.title)
                                    .font(.caption2)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 70)
                .background(
                    Color.white
                        .ignoresSafeArea()
                )
                .opacity(isTabBarHidden ? 0 : 1)
                .animation(.easeInOut, value: isTabBarHidden)
            }
            .padding(.bottom, tabBarBottomPadding)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

enum Tab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case settings = "Settings"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .settings: return "Settings"
        }
    }
    
    var image: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .settings: return "gearshape.fill"
        }
    }
}
