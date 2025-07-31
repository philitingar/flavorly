//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 31/7/25.
//
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageProcessor {
    static func preprocessImage(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // 1. Convert to grayscale
        let grayscale = ciImage.applyingFilter("CIColorControls", parameters: [
            kCIInputSaturationKey: 0.0
        ])
        
        // 2. Enhance contrast
        let contrasted = grayscale.applyingFilter("CIColorControls", parameters: [
            kCIInputContrastKey: 1.5
        ])
        
        // 3. Perspective correction (if needed)
        var perspectiveCorrected = contrasted
        if let detectedRectangle = detectRectangle(in: ciImage) {
            perspectiveCorrected = applyPerspectiveCorrection(to: contrasted, rectangle: detectedRectangle)
        }
        
        // Convert back to UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(perspectiveCorrected, from: perspectiveCorrected.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private static func detectRectangle(in image: CIImage) -> CIRectangleFeature? {
        let detector = CIDetector(ofType: CIDetectorTypeRectangle,
                                 context: nil,
                                 options: [
                                    CIDetectorAccuracy: CIDetectorAccuracyHigh,
                                    CIDetectorAspectRatio: 1.0
                                 ])
        
        let features = detector?.features(in: image)
        return features?.first as? CIRectangleFeature
    }
    
    private static func applyPerspectiveCorrection(to image: CIImage, rectangle: CIRectangleFeature) -> CIImage {
        let perspectiveCorrection = CIFilter.perspectiveCorrection()
        perspectiveCorrection.inputImage = image
        perspectiveCorrection.topLeft = rectangle.topLeft
        perspectiveCorrection.topRight = rectangle.topRight
        perspectiveCorrection.bottomLeft = rectangle.bottomLeft
        perspectiveCorrection.bottomRight = rectangle.bottomRight
        
        return perspectiveCorrection.outputImage ?? image
    }
}
