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
        let pdfDocument = PDFDocument()
        let pageSize = CGSize(width: 595.2, height: 841.8) // A4
        let footerHeight: CGFloat = 60
        let topMargin: CGFloat = 40
        let bottomMargin: CGFloat = 40
        let contentHeight = pageSize.height - footerHeight - topMargin - bottomMargin
        
        // Create content view with available height
        let contentView = RecipePDFContentView(recipe: recipe, availableHeight: contentHeight)
        
        // Create a hosting controller to render the content
        let hostingController = UIHostingController(rootView: contentView)
        
        // Set up a very large frame for measurement
        let measurementSize = CGSize(width: pageSize.width, height: 10000)
        hostingController.view.frame = CGRect(origin: .zero, size: measurementSize)
        hostingController.view.backgroundColor = UIColor.white
        
        // Force layout
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        
        // Get the actual content height (subtract the padding already in the view)
        let actualSize = hostingController.view.sizeThatFits(measurementSize)
        let totalContentHeight = actualSize.height - 80 // Remove the padding from measurement
        
        // Calculate number of pages needed
        let numberOfPages = max(1, Int(ceil(totalContentHeight / contentHeight)))
        
        // Create each page
        for pageIndex in 0..<numberOfPages {
            let yOffset = -CGFloat(pageIndex) * contentHeight + topMargin
            
            // Create the page image
            let renderer = UIGraphicsImageRenderer(size: pageSize)
            let pageImage = renderer.image { context in
                // Fill background
                UIColor.white.setFill()
                context.fill(CGRect(origin: .zero, size: pageSize))
                
                // Render content with offset
                context.cgContext.saveGState()
                context.cgContext.translateBy(x: 0, y: yOffset)
                
                let pageHostingController = UIHostingController(rootView: contentView)
                pageHostingController.view.frame = CGRect(origin: .zero, size: CGSize(width: pageSize.width, height: totalContentHeight + 80))
                pageHostingController.view.backgroundColor = UIColor.white
                pageHostingController.view.layoutIfNeeded()
                
                pageHostingController.view.drawHierarchy(
                    in: CGRect(origin: .zero, size: CGSize(width: pageSize.width, height: totalContentHeight + 80)),
                    afterScreenUpdates: true
                )
                
                context.cgContext.restoreGState()
                
                // Add footer at bottom
                let footerView = RecipePDFFooterView(pageNumber: pageIndex + 1, totalPages: numberOfPages)
                let footerController = UIHostingController(rootView: footerView)
                footerController.view.frame = CGRect(x: 0, y: pageSize.height - footerHeight, width: pageSize.width, height: footerHeight)
                footerController.view.backgroundColor = UIColor.white
                footerController.view.layoutIfNeeded()
                
                footerController.view.drawHierarchy(
                    in: CGRect(x: 0, y: pageSize.height - footerHeight, width: pageSize.width, height: footerHeight),
                    afterScreenUpdates: true
                )
            }
            
            // Add page to PDF
            if let pdfPage = PDFPage(image: pageImage) {
                pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
            }
        }
        
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
