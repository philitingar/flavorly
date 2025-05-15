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
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                    .environment(\.managedObjectContext, viewContext)
                
                SearchView(tag: Tag(), recipe: nil)
                    .tag(Tab.search)
                    .environment(\.managedObjectContext, viewContext)
                
                SettingsView(navigationPath: $settingsNavigationPath)
                    .tag(Tab.settings)
            }
            .toolbar(.hidden, for: .tabBar)
            
            VStack(spacing: 0) {
                Spacer()
                if #available(iOS 17.0, *) {
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
                                        .foregroundColor(selectedTab == tab ? themeManager.currentTheme.bottomTabButtonColorDark : themeManager.currentTheme.bottomTabButtonColorLight)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(
                        Color(themeManager.currentTheme.tabBarBackgroundColor)
                            .ignoresSafeArea()
                    )
                    .opacity(isTabBarHidden ? 0 : 1)
                    .animation(.easeInOut, value: isTabBarHidden)
                } else {
                    // Fallback on earlier versions
                }
            }
            .padding(.bottom, tabBarBottomPadding)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    // Only allow tab switching swipe if current tab's navigation path is empty (root)
                    let isAtSettingsRoot = settingsNavigationPath.isEmpty
                    if horizontalAmount < -50 {
                        // Swipe left
                        if selectedTab == .settings && !isAtSettingsRoot {
                            // In settings subview, so do NOT switch tab
                            return
                        }
                        else {
                            if let currentIndex = Tab.allCases.firstIndex(of: selectedTab),
                               currentIndex < Tab.allCases.count - 1 {
                                selectedTab = Tab.allCases[currentIndex + 1]
                            }
                        }
                    }
                    else if horizontalAmount > 50 {
                        // Swipe right
                        if selectedTab == .settings && !isAtSettingsRoot {
                            // In settings subview, so do NOT switch tab
                            return
                        }
                        else {
                            if let currentIndex = Tab.allCases.firstIndex(of: selectedTab),
                               currentIndex > 0 {
                                selectedTab = Tab.allCases[currentIndex - 1]
                            }
                        }
                    }
                }
        )
    }
}

enum Tab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case settings = "Settings"
    
    var image: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .settings: return "gearshape.fill"
        }
    }
}
