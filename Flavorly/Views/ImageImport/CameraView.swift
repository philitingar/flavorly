//
//  CameraView.swift
//  Flavourly
//
//  Created by Timea Bartha on 31/7/25.
//
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.coordinator = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func didCapturePhoto(_ image: UIImage) {
            parent.images.append(image)
        }
        
        func didFinish() {
            parent.dismiss()
        }
    }
}

class CameraViewController: UIViewController {
    var coordinator: CameraView.Coordinator?
    private var captureSession: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // UI Elements
    private let captureButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let thumbnailStack = UIStackView()
    private let countLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSession()
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            showAlert(title: "Camera Error", message: "Unable to access camera")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
        } catch {
            showAlert(title: "Camera Error", message: "Failed to initialize camera: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    private func setupUI() {
        // Capture button
        captureButton.setTitle("📷", for: .normal)
        captureButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        captureButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        captureButton.layer.cornerRadius = 40
        captureButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        // Done button
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        doneButton.backgroundColor = UIColor.systemBlue
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 8
        doneButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        // Count label
        countLabel.text = "0 photos"
        countLabel.textColor = .white
        countLabel.font = UIFont.boldSystemFont(ofSize: 16)
        countLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        countLabel.textAlignment = .center
        countLabel.layer.cornerRadius = 8
        countLabel.clipsToBounds = true
        
        // Add padding to label using a container view
        let countLabelContainer = UIView()
        countLabelContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        countLabelContainer.layer.cornerRadius = 8
        countLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel.backgroundColor = .clear
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabelContainer.addSubview(countLabel)
        
        // Thumbnail stack
        thumbnailStack.axis = .horizontal
        thumbnailStack.distribution = .fillEqually
        thumbnailStack.spacing = 8
        thumbnailStack.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        thumbnailStack.layer.cornerRadius = 8
        thumbnailStack.isLayoutMarginsRelativeArrangement = true
        thumbnailStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Add to view
        [captureButton, doneButton, countLabelContainer, thumbnailStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            // Capture button - bottom center
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.widthAnchor.constraint(equalToConstant: 80),
            captureButton.heightAnchor.constraint(equalToConstant: 80),
            
            // Done button - top right
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Count label container - top left
            countLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            countLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Count label inside container with padding
            countLabel.topAnchor.constraint(equalTo: countLabelContainer.topAnchor, constant: 8),
            countLabel.leadingAnchor.constraint(equalTo: countLabelContainer.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: countLabelContainer.trailingAnchor, constant: -12),
            countLabel.bottomAnchor.constraint(equalTo: countLabelContainer.bottomAnchor, constant: -8),
            
            // Thumbnail stack - bottom, above capture button
            thumbnailStack.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20),
            thumbnailStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            thumbnailStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            thumbnailStack.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        updatePhotoCount()
    }
    
    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Animate capture button
        UIView.animate(withDuration: 0.1, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.captureButton.transform = CGAffineTransform.identity
            }
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func done() {
        coordinator?.didFinish()
    }
    
    private func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }
    
    private func updatePhotoCount() {
        let count = coordinator?.parent.images.count ?? 0
        countLabel.text = "\(count) photo\(count == 1 ? "" : "s")"
        
        // Update thumbnails
        thumbnailStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let maxThumbnails = 5
        let imagesToShow = coordinator?.parent.images.suffix(maxThumbnails) ?? []
        
        for image in imagesToShow {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 4
            imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
            thumbnailStack.addArrangedSubview(imageView)
        }
        
        if (coordinator?.parent.images.count ?? 0) > maxThumbnails {
            let moreLabel = UILabel()
            moreLabel.text = "+\((coordinator?.parent.images.count ?? 0) - maxThumbnails)"
            moreLabel.textColor = .white
            moreLabel.font = UIFont.boldSystemFont(ofSize: 12)
            moreLabel.textAlignment = .center
            moreLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            moreLabel.layer.cornerRadius = 4
            moreLabel.clipsToBounds = true
            moreLabel.widthAnchor.constraint(equalToConstant: 44).isActive = true
            thumbnailStack.addArrangedSubview(moreLabel)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.coordinator?.didFinish()
        })
        present(alert, animated: true)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            showAlert(title: "Capture Error", message: "Failed to capture photo: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            showAlert(title: "Processing Error", message: "Failed to process captured photo")
            return
        }
        
        // Fix orientation based on device orientation
        let fixedImage = fixImageOrientation(image)
        
        // Process image on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let processedImage = ImageProcessor.preprocessImage(fixedImage) ?? fixedImage
            
            DispatchQueue.main.async {
                self.coordinator?.didCapturePhoto(processedImage)
                self.updatePhotoCount()
                
                // Flash effect
                let flashView = UIView(frame: self.view.bounds)
                flashView.backgroundColor = .white
                flashView.alpha = 0.8
                self.view.addSubview(flashView)
                
                UIView.animate(withDuration: 0.2) {
                    flashView.alpha = 0
                } completion: { _ in
                    flashView.removeFromSuperview()
                }
            }
        }
    }
    
    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        // If image is already correctly oriented, return as is
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? image
    }
}
