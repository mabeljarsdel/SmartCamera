//
//  CaptureExt.swift
//  scannerApp
//
//  Created by Maksym on 03.12.2020.
//

import Foundation
import UIKit
import AVFoundation
import MLKit

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        
        lastFrame = sampleBuffer
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = ciImage.convertToCGImage() else { return }

        let uiImage = UIImage(cgImage: cgImage)
        
        let visionImage = VisionImage(image: uiImage)
        visionImage.orientation = uiImage.imageOrientation


        let imageWidth = CGFloat(uiImage.size.width)
        let imageHeight = CGFloat(uiImage.size.height)
        
        
        switch self.currentMode {
        case .normal:
            if !takePicture {
                DispatchQueue.main.sync {
                    updatePreviewOverlayView()
                    removeDetectionAnnotations()
                }
                return
            }
            
            self.takePicture = false
            
            DispatchQueue.main.sync {
                let imagePreview = ImagePreviewController()
                
                imagePreview.imagePreviewView.imageView.image = self.previewOverlayView.image
                
                imagePreview.modalPresentationStyle = .formSheet
                self.present(imagePreview, animated: true)
                
            }
        case .objectDetection:
            print("object detection execute")
            let options = ObjectDetectorOptions()
            options.shouldEnableClassification = true
            options.detectorMode = .singleImage
            let objDetector = ObjectDetectionUtil()
            objDetector.detectObjectOnDevice(in: visionImage, width: imageWidth, height: imageHeight, options: options)
            
        case .landmarkDetection:
            print("landmark detection execute")
        case .translation:
            self.recognizeTextOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
            print("recog")
        case .imageLabeling:
            print("image labeling execute")
        }
    }
    
    
    private func recognizeTextOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        var recognizedText: Text
        do {
            recognizedText = try TextRecognizer.textRecognizer().results(in: image)
            print(recognizedText.text)
        } catch let error {
            print("Failed to recognize text with error: \(error.localizedDescription).")
            return
        }
        weak var weakSelf = self
        DispatchQueue.main.sync {
            guard let strongSelf = weakSelf else {
                print("Self is nil!")
                return
            }
            strongSelf.updatePreviewOverlayView()
            strongSelf.removeDetectionAnnotations()
            
            // Blocks.
            for block in recognizedText.blocks {
                for line in block.lines {
                    
                    let transformedRect = line.frame.applying(AddRectangleToImageHelper.transformMatrix(imageView: self.previewOverlayView))
                    
                    
                    UIUtilities.addRectangle(
                        transformedRect,
                        to: self.annotationOverlayView,
                        color: UIColor.white
                    )
                    
                    let translator = TranslatorController.translatorInstance
                    
                    translator.translate(in: line.text, callback: { translatedText, error in
                        if error != nil {
                            print(error)
                        } else {
                            let label = UILabel(frame: transformedRect)
                            
                            label.text = translatedText
                            label.adjustsFontSizeToFitWidth = true
                            strongSelf.annotationOverlayView.addSubview(label)
                        }
                        
                    })

//                    for element in line.elements {
//
//                        let transformedRect = element.frame.applying(AddRectangleToImageHelper.transformMatrix(imageView: self.previewOverlayView))
//
//
//                        UIUtilities.addRectangle(
//                            transformedRect,
//                            to: self.annotationOverlayView,
//                            color: UIColor.white
//                        )
//
//                        let translator = TranslatorController.translatorInstance
//
//                        let label = UILabel(frame: transformedRect)
//
//                        label.text = element.text
//                        label.adjustsFontSizeToFitWidth = true
//                        strongSelf.annotationOverlayView.addSubview(label)
//                    }
                }
            }
        }
    }
    
    
    private func convertedPoints(
        from points: [NSValue]?,
        width: CGFloat,
        height: CGFloat
    ) -> [NSValue]? {
        return points?.map {
            let cgPointValue = $0.cgPointValue
            let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
            let cgPoint = cameraMainView.cameraView.preview.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
            let value = NSValue(cgPoint: cgPoint)
            return value
        }
    }
    private func updatePreviewOverlayView() {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let rotatedImage = UIImage(cgImage: cgImage)
        previewOverlayView.image = rotatedImage
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
}
