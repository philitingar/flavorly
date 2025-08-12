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
    @Published var isGeneratingPDF = false
    var tempPDFURL: URL?
    
    @MainActor func shareRecipe(_ recipe: Recipe) {
        isGeneratingPDF = true
        
        Task {
            // Generate the PDF document
            let pdfDocument = RecipePDFService.generatePDF(for: recipe)
            
            // Save to temporary file with sanitized filename
            let sanitizedTitle = recipe.title?
                .replacingOccurrences(of: "/", with: "-")
                .replacingOccurrences(of: "\\", with: "-")
                .replacingOccurrences(of: ":", with: "-") ?? "Recipe"
            
            tempPDFURL = RecipePDFService.savePDFToTempFile(
                pdfDocument,
                filename: sanitizedTitle
            )
            
            isGeneratingPDF = false
            
            // Show the share sheet
            if tempPDFURL != nil {
                showShareSheet = true
            }
        }
    }
    
    func getShareItems() -> [Any] {
        guard let url = tempPDFURL else { return [] }
        
        // Verify the file exists before sharing
        if FileManager.default.fileExists(atPath: url.path) {
            return [url]
        }
        return []
    }
    
    func cleanup() {
        // Clean up the temporary file when done
        if let url = tempPDFURL, FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        tempPDFURL = nil
        showShareSheet = false
    }
}
