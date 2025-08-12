//
//  RecipeSharingViewModel.swift
//  Flavourly
//
//  Created by Timea Bartha on 12/8/25.
//

import SwiftUI
import CoreData

class RecipeSharingViewModel: ObservableObject {
    @Published var showShareSheet = false
    var tempPDFURL: URL?
    
    @MainActor func shareRecipe(_ recipe: Recipe) {
        let pdfDocument = RecipePDFService.generatePDF(for: recipe)
        tempPDFURL = RecipePDFService.savePDFToTempFile(
            pdfDocument,
            filename: recipe.title ?? "Recipe"
        )
        showShareSheet = true
    }
    
    func getShareItems() -> [Any] {
        guard let url = tempPDFURL else { return [] }
        return [url]
    }
    
    func cleanup() {
        if let url = tempPDFURL {
            try? FileManager.default.removeItem(at: url)
        }
    }
}
