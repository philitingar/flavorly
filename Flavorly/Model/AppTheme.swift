//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//


import SwiftUI

struct AppTheme: Identifiable, Hashable {
    let id: String
    let name: String

    let preferredColorScheme: ColorScheme
    let appBackgroundColor: Color
    
    // Text
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let viewTitleColor: Color
    let viewSubTitleColor: Color

    // Interactive Elements / Accents
    let addButtonColor: Color
    let searchButtonColor: Color
    let deleteButtonColor: Color
    
    let bottomTabButtonColorLight: Color
    let bottomTabButtonColorDark: Color
    let tabBarBackgroundColor: Color
    // Other UI Elements
    let dividerColor: Color

    let accentColor: Color
    let textFieldBackgroundColor: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AppTheme, rhs: AppTheme) -> Bool {
        lhs.id == rhs.id
    }
}
extension AppTheme {
    static let basicWhite = AppTheme(
        id: "basicWhite",
        name: "Basic Light",
        preferredColorScheme: .light,
        appBackgroundColor: Color(white: 0.95),
        
        primaryTextColor: Color.black,
        secondaryTextColor: Color.secondary,
        
        viewTitleColor: Color.black,
        viewSubTitleColor: Color.black,

        addButtonColor: Color.green,
        searchButtonColor: Color.blue,
        deleteButtonColor: Color.red,
        
        bottomTabButtonColorLight: Color.secondary,
        bottomTabButtonColorDark: Color.black,
        tabBarBackgroundColor: Color(white: 0.95),

        dividerColor: Color.black,
        accentColor: Color.secondary,
        textFieldBackgroundColor: Color.black.opacity(0.2)
  
    )
    static let basicBlack = AppTheme(
        id: "basicBlack",
        name: "Basic Dark",
        preferredColorScheme: .dark,
        appBackgroundColor: Color.black,
        
        primaryTextColor: Color.white,
        secondaryTextColor: Color.secondary,
        viewTitleColor: Color.white,
        viewSubTitleColor: Color.white,

        addButtonColor: Color.green,
        searchButtonColor: Color.blue,
        deleteButtonColor: Color.red,
        
        bottomTabButtonColorLight: Color.secondary,
        bottomTabButtonColorDark: Color.white,
        tabBarBackgroundColor: Color.black,

        dividerColor: Color.white,
        accentColor: Color.gray,
        textFieldBackgroundColor: Color.white.opacity(0.1)
 
    )
    static let darkFantasyForest = AppTheme(
            id: "dark_fantasy_forest",
            name: "Dark Fantasy Forest",
            preferredColorScheme: .dark,
            appBackgroundColor: .darkForestGreen,
            primaryTextColor: .softGlowGreen,
            secondaryTextColor: .mutedLeafGreen,
            viewTitleColor: .goldenYellow,
            viewSubTitleColor: .softAquamarine,
            addButtonColor: .glowingInsectGreen,
            searchButtonColor: .coral,
            deleteButtonColor: .deepRed,
            bottomTabButtonColorLight: .glowingInsectGreen,
            bottomTabButtonColorDark: .mutedLeafGreen,
            tabBarBackgroundColor: .darkForestGreen,
            dividerColor: .forestGreenDivider,
            accentColor: .goldenYellow,
            textFieldBackgroundColor: .darkGray // Using dark gray here, you can also modify it
        )
    static let fantasyBabyGreen = AppTheme(
        id: "fantasy_baby_green",
               name: "Fantasy Baby Green",
               preferredColorScheme: .light,
               appBackgroundColor: .fantasyBabyGreenBackground,
               primaryTextColor: .sparklingMint,
               secondaryTextColor: .magicalLavender,
               viewTitleColor: .emeraldAccent,
               viewSubTitleColor: .enchantedPink,
               addButtonColor: .emeraldAccent,
               searchButtonColor: .calmingCyan,
               deleteButtonColor: .twilightPurple,
               bottomTabButtonColorLight: .mistyGray,
               bottomTabButtonColorDark: .darkGray,
               tabBarBackgroundColor: .fantasyBabyGreenBackground,
               dividerColor: .sparklingMint,
               accentColor: .fairyDustYellow,
               textFieldBackgroundColor: .mistyGray    
        )
    static let pinkBubbleGum = AppTheme(
            id: "pink_bubble_gum",
            name: "Pink Bubble Gum",
            preferredColorScheme: .light,
            appBackgroundColor: .bubbleGumBackground,
            primaryTextColor: .darkBubbleGum,
            secondaryTextColor: .darkRose,
            viewTitleColor: .sweetCandiedPink,
            viewSubTitleColor: .lavenderPurple,
            addButtonColor: .raspberryRed,
            searchButtonColor: .cottonCandyBlue,
            deleteButtonColor: .darkRose,
            bottomTabButtonColorLight: .darkBubbleGum,
            bottomTabButtonColorDark: .raspberryRed,
            tabBarBackgroundColor: .bubbleGumBackground,
            dividerColor: .darkBubbleGum,
            accentColor: .sweetCandiedPink,
            textFieldBackgroundColor: .softGray
        )
    static let darkPinkNeon = AppTheme(
            id: "dark_pink_neon",
            name: "Dark Pink Neon",
            preferredColorScheme: .dark,
            appBackgroundColor: .neonBlack,
            primaryTextColor: .neonPink,
            secondaryTextColor: .brightNeonMagenta,
            viewTitleColor: .vibrantFuchsia,
            viewSubTitleColor: .electricBlue,
            addButtonColor: .neonPurple,
            searchButtonColor: .neonPink,
            deleteButtonColor: .brightNeonMagenta,
            bottomTabButtonColorLight: .neonPurple,
            bottomTabButtonColorDark: .vibrantFuchsia,
            tabBarBackgroundColor: .neonBlack,
            dividerColor: .neonPink,
            accentColor: .brightNeonMagenta,
            textFieldBackgroundColor: .softGrayish
        )
    static let frostyBlue = AppTheme(
            id: "frosty_blue",
            name: "Frosty Blue",
            preferredColorScheme: .light,
            appBackgroundColor: .frostyBlueBackground,
            primaryTextColor: .glacierBlue,
            secondaryTextColor: .icyTurquoise,
            viewTitleColor: .deepIceBlue,
            viewSubTitleColor: .ceruleanBlue,
            addButtonColor: .paleAqua,
            searchButtonColor: .glacierBlue,
            deleteButtonColor: .deepIceBlue,
            bottomTabButtonColorLight: .glacierBlue,
            bottomTabButtonColorDark: .deepIceBlue,
            tabBarBackgroundColor: .frostyBlueBackground,
            dividerColor: .frostGray,
            accentColor: .icyTurquoise,
            textFieldBackgroundColor: .frostGray
        )
    static let neonBlue = AppTheme(
            id: "neon_blue",
            name: "Neon Blue",
            preferredColorScheme: .dark,
            appBackgroundColor: .neonBlack,
            primaryTextColor: .neonBlue,
            secondaryTextColor: .brightNeonCyan,
            viewTitleColor: .electricBlue,
            viewSubTitleColor: .vividSkyBlue,
            addButtonColor: .neonTurquoise,
            searchButtonColor: .brightBlueViolet,
            deleteButtonColor: .electricBlue,
            bottomTabButtonColorLight: .electricBlue,
            bottomTabButtonColorDark: .softGray,
            tabBarBackgroundColor: .neonBlack,
            dividerColor: .neonBlue,
            accentColor: .neonTurquoise,
            textFieldBackgroundColor: .softGray
        )
    static let availableThemes: [AppTheme] = [
        .basicBlack,
        .basicWhite,
        .darkFantasyForest,
        .fantasyBabyGreen,
        .pinkBubbleGum,
        .darkPinkNeon,
        .frostyBlue,
        .neonBlue
        
        // Add more themes here later
    ]

    static func find(by id: String?) -> AppTheme {
        guard let id = id, let theme = availableThemes.first(where: { $0.id == id }) else {
            return .basicBlack
        }
        return theme
    }
}
