//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 16/5/25.
//

import SwiftUI
import UIKit
import QuickLook // 1. Import QuickLook

// 2. Create a QLPreviewController based viewer
struct QLDocumentViewer: UIViewControllerRepresentable {
    let fileURL: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        // You can optionally set the starting item if you have more than one.
        // controller.currentPreviewItemIndex = 0 // Not needed for a single item
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
        // If the fileURL could change, tell the QLPreviewController to reload.
        // For a static URL as in PrivacyView, this might not be strictly necessary
        // on every update, but it's good practice if the view could be reused.
        uiViewController.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: QLDocumentViewer

        init(parent: QLDocumentViewer) {
            self.parent = parent
        }

        // Tells the QLPreviewController how many items to preview
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1 // We are only showing one document
        }

        // Provides the QLPreviewItem for a given index
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            // URL conforms to QLPreviewItem.
            // For safety, it's often cast to NSURL.
            return parent.fileURL as NSURL
        }
    }
}
