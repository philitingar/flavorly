//
//  RecipePDFService.swift
//  Flavourly
//
//  Created by Timea Bartha on 12/8/25.
//

import SwiftUI
import PDFKit
import CoreData

class RecipePDFService {
    @MainActor static func generatePDF(for recipe: Recipe) -> PDFDocument {
        let view = RecipePDFView(recipe: recipe)
        let hostingController = UIHostingController(rootView: view)
        
        // Calculate required size (A4 dimensions in points)
        let pageSize = CGSize(width: 595.2, height: 841.8)
        hostingController.view.frame = CGRect(origin: .zero, size: pageSize)
        
        // Render the view to an image
        let renderer = UIGraphicsImageRenderer(size: pageSize)
        let image = renderer.image { context in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        
        // Create PDF from the image
        let pdfDocument = PDFDocument()
        let pdfPage = PDFPage(image: image)
        pdfDocument.insert(pdfPage!, at: 0)
        
        return pdfDocument
    }
    
    static func savePDFToTempFile(_ pdfDocument: PDFDocument, filename: String) -> URL? {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(filename).pdf")
        
        if pdfDocument.write(to: tempURL) {
            return tempURL
        }
        return nil
    }
}
