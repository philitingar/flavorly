//
//  FlavourlyTheme.swift
//  Flavourly
//
//  Created by Timea Bartha on 28/6/24.
//

import Foundation
import SwiftUI
// MARK: Theme
struct Theme: Equatable {
    let backgroundColor: Color
    let textColor: Color
    let titleColor: Color
    let searchIconColor: Color //search
    let addIconColor: Color // add, edit
    let deleteIconColor: Color //back, delete, X
    let listBackgroundColor: Color
    let secondaryColor: Color
    let sectionBackgroundColor: Color
    let preferredColorScheme: CustomColorPalette?
    
    var colorScheme: ColorScheme? {
            return preferredColorScheme?.colorScheme
        }
}

let lightOriginal = Theme(backgroundColor: .white, textColor: .black, titleColor: FlavourlyColor.blue.dark, searchIconColor: FlavourlyColor.blue.dark, addIconColor: FlavourlyColor.green.dark, deleteIconColor:FlavourlyColor.red.dark, listBackgroundColor: .secondary.opacity(0.3), secondaryColor: .secondary, sectionBackgroundColor: .white, preferredColorScheme: .light)
let darkOriginal = Theme(backgroundColor: .black, textColor: .white, titleColor: FlavourlyColor.blue.light, searchIconColor: FlavourlyColor.blue.light, addIconColor: FlavourlyColor.green.light, deleteIconColor:FlavourlyColor.red.light, listBackgroundColor: FlavourlyColor.blue.light.opacity(0.3), secondaryColor: .secondary, sectionBackgroundColor: .gray.opacity(0.7), preferredColorScheme: .dark)

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = darkOriginal {
        didSet {
            saveTheme()
        }
    }
    
    init() {
        loadTheme()
    }
    
    private func saveTheme() {
        let themeName: String
        switch currentTheme {
        case lightOriginal:
            themeName = "lightOriginal"
        case darkOriginal:
            themeName = "darkOriginal"
        default:
            themeName = "lightOriginal" // Default or additional themes can be handled here
        }
        
        UserDefaults.standard.set(themeName, forKey: "selectedTheme")
    }
    
    private func loadTheme() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") {
            switch savedTheme {
            case "lightOriginal":
                currentTheme = lightOriginal
            case "darkOriginal":
                currentTheme = darkOriginal
            default:
                currentTheme = lightOriginal // Default or additional themes can be handled here
            }
        } else {
            currentTheme = lightOriginal // Default theme if nothing is saved
        }
    }
}

// MARK: Custom Color Scheme
enum CustomColorScheme {
    case light, dark
}
// MARK: Color Mapping Structure

struct CustomColorPalette: Equatable {
    var backgroundColor: Color
    var textColor: Color
    var textFieldBackgroundColor: Color
    var buttonBackgroundColor: Color
    var buttonTextColor: Color
    var navigationBarBackgroundColor: UIColor
    var navigationBarTitleColor: UIColor
    var accentColor: Color
    var placeholderColor: Color
    var dividerColor: Color
    var progressColor: Color
    var toggleTintColor: Color
    var sliderMinTrackColor: Color
    var sliderMaxTrackColor: Color
    var sliderThumbColor: Color
    var iconTintColor: Color
    
    func toColorScheme() -> ColorScheme? {
           switch self {
           case CustomColorPalette.light:
               return .light
           case CustomColorPalette.dark:
               return .dark
           default:
               return nil
           }
       }
    
    static let light = CustomColorPalette(
        backgroundColor: .white,
        textColor: .black,
        textFieldBackgroundColor: .gray.opacity(0.2),
        buttonBackgroundColor: .blue,
        buttonTextColor: .white,
        navigationBarBackgroundColor: .white,
        navigationBarTitleColor: .black,
        accentColor: .blue,
        placeholderColor: .gray,
        dividerColor: .gray,
        progressColor: .blue,
        toggleTintColor: .blue,
        sliderMinTrackColor: .blue,
        sliderMaxTrackColor: .gray,
        sliderThumbColor: .blue,
        iconTintColor: .blue
    )
    static let dark = CustomColorPalette(
            backgroundColor: .black,
            textColor: .white,
            textFieldBackgroundColor: .gray.opacity(0.5),
            buttonBackgroundColor: .gray,
            buttonTextColor: .black,
            navigationBarBackgroundColor: .black,
            navigationBarTitleColor: .white,
            accentColor: .gray,
            placeholderColor: .gray,
            dividerColor: .gray,
            progressColor: .gray,
            toggleTintColor: .gray,
            sliderMinTrackColor: .gray,
            sliderMaxTrackColor: .gray,
            sliderThumbColor: .gray,
            iconTintColor: .gray
        )
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
}
// MARK: Modify the Environment to Include Color Mappings
struct CustomColorPaletteKey: EnvironmentKey {
    static let defaultValue: CustomColorPalette = .light
}

extension EnvironmentValues {
    var customColorPalette: CustomColorPalette {
        get { self[CustomColorPaletteKey.self] }
        set { self[CustomColorPaletteKey.self] = newValue }
    }
}
// MARK: Create Custom View Modifiers
struct CustomBackgroundModifier: ViewModifier {
    @Environment(\.customColorPalette) var customColorPalette
    
    func body(content: Content) -> some View {
        content
            .background(customColorPalette.backgroundColor)
    }
}

struct CustomTextColorModifier: ViewModifier {
    @Environment(\.customColorPalette) var customColorPalette
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(customColorPalette.textColor)
    }
}

struct CustomTextFieldModifier: ViewModifier {
    @Environment(\.customColorPalette) var customColorPalette
    
    func body(content: Content) -> some View {
        content
            .background(customColorPalette.textFieldBackgroundColor)
            .foregroundColor(customColorPalette.textColor)
            .padding()
            .cornerRadius(8)
    }
}

struct CustomButtonModifier: ViewModifier {
    @Environment(\.customColorPalette) var customColorPalette
    
    func body(content: Content) -> some View {
        content
            .background(customColorPalette.buttonBackgroundColor)
            .foregroundColor(customColorPalette.buttonTextColor)
            .padding()
            .cornerRadius(8)
    }
}
struct CustomNavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var titleColor: UIColor
    
    init(backgroundColor: UIColor, titleColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(titleColor))
    }
}

// Placeholder Color Modifier
struct CustomPlaceholderModifier: ViewModifier {
    var placeholderColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(placeholderColor)
    }
}

// Divider Color Modifier
struct CustomDividerModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        Divider()
            .background(color)
            .padding()
    }
}

// Progress View Modifier
struct CustomProgressViewModifier: ViewModifier {
    var progressColor: Color
    
    func body(content: Content) -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: progressColor))
            .padding()
    }
}

// Toggle Style Modifier
struct CustomToggleModifier: ViewModifier {
    var tintColor: Color
    
    func body(content: Content) -> some View {
        Toggle(isOn: .constant(true)) {
            Text("Custom Toggle")
        }
        .toggleStyle(SwitchToggleStyle(tint: tintColor))
    }
}

// Slider Style Modifier
struct CustomSliderModifier: ViewModifier {
    var minTrackColor: Color
    var maxTrackColor: Color
    var thumbColor: Color
    
    func body(content: Content) -> some View {
        Slider(value: .constant(0.5))
            .accentColor(minTrackColor)
            .background(maxTrackColor)
            .foregroundColor(thumbColor)
    }
}
extension View {
    func customBackground() -> some View {
        self.modifier(CustomBackgroundModifier())
    }
    
    func customTextColor() -> some View {
        self.modifier(CustomTextColorModifier())
    }
    
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldModifier())
    }
    
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonModifier())
    }
    func customNavigationBar(backgroundColor: UIColor, titleColor: UIColor) -> some View {
        self.modifier(CustomNavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
    
    func customPlaceholderColor(_ color: Color) -> some View {
        self.modifier(CustomPlaceholderModifier(placeholderColor: color))
    }
    
    func customDividerColor(_ color: Color) -> some View {
        self.modifier(CustomDividerModifier(color: color))
    }
    
    func customProgressViewStyle(progressColor: Color) -> some View {
        self.modifier(CustomProgressViewModifier(progressColor: progressColor))
    }
    
    func customToggleStyle(tintColor: Color) -> some View {
        self.modifier(CustomToggleModifier(tintColor: tintColor))
    }
    
    func customSliderStyle(minTrackColor: Color, maxTrackColor: Color, thumbColor: Color) -> some View {
        self.modifier(CustomSliderModifier(minTrackColor: minTrackColor, maxTrackColor: maxTrackColor, thumbColor: thumbColor))
    }
}
