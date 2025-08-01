//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 31/7/25.
//
import SwiftUI
import CoreData
import Vision
import VisionKit

struct RecipeImportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showImagePicker = false
    @State private var inputImages = [UIImage]()
    @State private var recognizedText = ""
    @State private var parsedRecipe = ParsedRecipe()
    @State private var showEditView = false
    @State private var isLoading = false
    @State private var showCameraNotAvailableAlert = false
    @State private var importHistory = [ImportedRecipe]()
    @State private var currentPage = 0
    @State private var processingProgress = 0.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
                VStack(spacing: 20) {
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView("Processing recipe...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.5)
                            
                            if processingProgress > 0 {
                                ProgressView(value: processingProgress)
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .frame(maxWidth: 200)
                                
                                Text("\(Int(processingProgress * 100))% Complete")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    } else if !inputImages.isEmpty {
                        // Image preview section
                        VStack(spacing: 16) {
                            // Photo count and navigation
                            HStack {
                                Text("\(inputImages.count) photo\(inputImages.count == 1 ? "" : "s") captured")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if inputImages.count > 1 {
                                    Text("\(currentPage + 1) of \(inputImages.count)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.secondary.opacity(0.2))
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Image carousel
                            TabView(selection: $currentPage) {
                                ForEach(inputImages.indices, id: \.self) { index in
                                    VStack {
                                        Image(uiImage: inputImages[index])
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(12)
                                            .shadow(radius: 4)
                                            .tag(index)
                                        
                                        // Delete button for individual images
                                        Button(action: {
                                            deleteImage(at: index)
                                        }) {
                                            Label("Delete Photo", systemImage: "trash")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                        .padding(.top, 8)
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: inputImages.count > 1 ? .automatic : .never))
                            .frame(height: 300)
                            .padding(.horizontal)
                            
                            // Recognized text preview
                            if !recognizedText.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Recognized Text")
                                            .font(.headline)
                                        Spacer()
                                        Text("\(recognizedText.count) characters")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    ScrollView {
                                        Text(recognizedText)
                                            .font(.system(.body, design: .monospaced))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                    }
                                    .frame(maxHeight: 150)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                            }
                            
                            // Action buttons
                            VStack(spacing: 12) {
                                
                                Button {
                                    showImagePicker = true
                                } label: {
                                    Text("Add More Photos")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                                        .background(themeManager.currentTheme.secondaryTextColor)
                                        .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                                
                                HStack(spacing: 12) {
                                    Button {
                                        showEditView = true
                                    } label: {
                                        Text("Edit & Save")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                                            .background(themeManager.currentTheme.secondaryTextColor)
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(recognizedText.isEmpty)
                                    
                                    
                                    Button {
                                        resetImport()
                                    } label: {
                                        Text("Reset All")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                                            .background(themeManager.currentTheme.secondaryTextColor)
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // Initial state
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 60))
                                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                                
                                VStack(spacing: 8) {
                                    Text("Import Recipe from Photos")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.currentTheme.primaryTextColor)
                                    
                                    Text("Take photos of recipe pages and we'll extract the text for you")
                                        .font(.body)
                                        .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .symbolEffect(.bounce, options: .repeating)
                            
                            Button {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    showImagePicker = true
                                } else {
                                    showCameraNotAvailableAlert = true
                                }
                            } label: {
                                Label("Take Photos", systemImage: "camera.fill")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                                    .background(themeManager.currentTheme.secondaryTextColor) // Background for label only
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                            // Tips section
                            VStack(alignment: .leading, spacing: 12) {
                                Text(LocalizedStringKey("Tips for better results:"))
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    tipRow(icon: "lightbulb", text: "Ensure good lighting")
                                    tipRow(icon: "camera.aperture", text: "Keep the camera steady")
                                    tipRow(icon: "doc.text", text: "Capture text clearly")
                                    tipRow(icon: "photo.stack", text: "Take multiple photos if needed")
                                }
                            }
                            .padding()
                            .background(themeManager.currentTheme.secondaryTextColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Important:")
                                    .font(.headline)
                                    .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    tipRow(icon: "exclamationmark.triangle", text: "At the moment the photos option is only available in English.")
                                    tipRow(icon: "lightbulb.min.badge.exclamationmark", text: "We are working on adding more languages, but feel free to try it out")
                                    tipRow(icon: "person.badge.shield.exclamationmark", text: "The picture might not accurately represent the recipe, but it should give you a good starting point")
                                }
                            }
                            .padding()
                            .background(themeManager.currentTheme.secondaryTextColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
                .fullScreenCover(isPresented: $showImagePicker) {
                    CameraView(images: $inputImages)
                        .onDisappear {
                            if !inputImages.isEmpty && recognizedText.isEmpty {
                                processImages()
                            }
                        }
                }
                .sheet(isPresented: $showEditView) {
                    RecipeEditView(parsedRecipe: $parsedRecipe) {
                        saveRecipe()
                    } onCancel: {
                        // Just dismiss
                    }
                }
                .alert("Camera Not Available", isPresented: $showCameraNotAvailableAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("This device doesn't have a camera or camera access is restricted.")
                }
            }
        }
    }
    
    @ViewBuilder
    private func tipRow(icon: String, text: LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.currentTheme.appBackgroundColor)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(themeManager.currentTheme.appBackgroundColor)
            
            Spacer()
        }
    }
    
    private func deleteImage(at index: Int) {
        withAnimation {
            inputImages.remove(at: index)
            if currentPage >= inputImages.count {
                currentPage = max(0, inputImages.count - 1)
            }
            
            if inputImages.isEmpty {
                resetImport()
            } else {
                // Re-process remaining images
                processImages()
            }
        }
    }
    
    private func processImages() {
        guard !inputImages.isEmpty else { return }
        
        isLoading = true
        recognizedText = ""
        parsedRecipe = ParsedRecipe()
        processingProgress = 0.0
        
        DispatchQueue.global(qos: .userInitiated).async {
            var combinedText = ""
            let parser = RecipeParser()
            let totalImages = inputImages.count
            
            for (index, image) in inputImages.enumerated() {
                if let processedImage = ImageProcessor.preprocessImage(image) {
                    self.recognizeText(from: processedImage) { text in
                        combinedText += text + "\n\n"
                        
                        DispatchQueue.main.async {
                            self.processingProgress = Double(index + 1) / Double(totalImages)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.recognizedText = combinedText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.parsedRecipe = parser.parseRecipe(text: self.recognizedText)
                self.isLoading = false
                self.processingProgress = 0.0
            }
        }
    }
    
    private func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            let result: String
            if let observations = request.results as? [VNRecognizedTextObservation] {
                result = observations.compactMap {
                    $0.topCandidates(1).first?.string
                }.joined(separator: "\n")
            } else {
                result = ""
            }
            completion(result)
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
        } catch {
            print("OCR error: \(error)")
            completion("")
        }
    }
    
    private func resetImport() {
        withAnimation {
            inputImages.removeAll()
            recognizedText = ""
            parsedRecipe = ParsedRecipe()
            currentPage = 0
        }
    }
    
    private func saveRecipe() {
        let newRecipe = Recipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.title = parsedRecipe.title
        newRecipe.ingredients = parsedRecipe.ingredients.joined(separator: "\n")
        newRecipe.text = parsedRecipe.instructions.joined(separator: "\n")
        newRecipe.timestamp = Date()
        newRecipe.author = "Imported"
        
        let historyItem = ImportedRecipe(
            title: parsedRecipe.title,
            ingredients: parsedRecipe.ingredients,
            instructions: parsedRecipe.instructions,
            date: Date()
        )
        importHistory.insert(historyItem, at: 0)
        
        do {
            try viewContext.save()
            resetImport()
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
}

struct ImportedRecipe: Identifiable {
    let id = UUID()
    let title: String
    let ingredients: [String]
    let instructions: [String]
    let date: Date
}

extension String {
    
    func contains(regex: NSRegularExpression) -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
