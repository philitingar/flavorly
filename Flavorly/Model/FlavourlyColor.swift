//
//  FlavourlyColor.swift
//  Flavourly
//
//  Created by Timea Bartha on 28/6/24.
//

import Foundation
import SwiftUI

enum FlavourlyColor: String {
    case beige
    case red
    case blue
    case green

    var normalHex: String {
        switch self {
            // original colors
        case .beige: return "#DBBDC6"
        case .red: return "#F45B69"
        case .blue: return "#AFD2E9"
        case .green: return "#5AAF75"
        }
    }
    
    var darkHex: String {
        switch self {
            // original colors
        case .beige: return "#512D38"
        case .red: return "#AC0C19"
        case .blue: return "#2C72A0"
        case .green: return "#4E6E5D"
        }
    }

    var light: Color {
        return Color(hex: self.normalHex)
    }

    var dark: Color {
        return Color(hex: self.darkHex)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet.alphanumerics.inverted).trimmingCharacters(in: CharacterSet.alphanumerics.inverted).lowercased()
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Fallback to black color with full opacity
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

/* To use:
*** struct ContentView: View {
     @Environment(\.colorScheme) var colorScheme
 
**** FlavourlyColor.blue.dark
 
 
 */

