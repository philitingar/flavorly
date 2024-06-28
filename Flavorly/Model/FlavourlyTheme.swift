//
//  FlavourlyTheme.swift
//  Flavourly
//
//  Created by Timea Bartha on 28/6/24.
//

import Foundation
import SwiftUI

struct Theme {
    let backgroundColor: Color
    let textColor: Color
    let titleColor: Color
    let searchIconColor: Color //search
    let addIconColor: Color // add, edit
    let deleteIconColor: Color //back, delete, X
    let listBackgroundColor: Color
    let secondaryColor: Color
}
let lightTheme = Theme(backgroundColor: .white, textColor: .black, titleColor: FlavourlyColor.blue.dark, searchIconColor: FlavourlyColor.blue.dark, addIconColor: FlavourlyColor.green.dark, deleteIconColor:FlavourlyColor.red.dark, listBackgroundColor: .secondary.opacity(0.3), secondaryColor: .secondary)

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = lightTheme
}
