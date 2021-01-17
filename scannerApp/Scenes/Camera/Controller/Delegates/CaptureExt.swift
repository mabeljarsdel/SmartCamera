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
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        
        lastFrame = sampleBuffer
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = ciImage.convertToCGImage() else { return }

        let uiImage = UIImage(cgImage: cgImage)
        
        let visionImage = VisionImage(image: uiImage)
        visionImage.orientation = UIUtilities.imageOrientation(fromDevicePosition: .back)
        print(visionImage.orientation.rawValue)


        let imageWidth = CGFloat(uiImage.size.width)
        let imageHeight = CGFloat(uiImage.size.height)
        
        
        switch self.currentMode {
        case .normal:
//            self.cameraMainView.cameraView.removeFromSuperview()
            if !takePicture {
                DispatchQueue.main.sync {
                    updatePreviewOverlayView()
                    removeDetectionAnnotations()
                }
                return //we have nothing to do with the image buffer
            }
            
            self.takePicture = false
            
            DispatchQueue.main.sync {
                let imagePreview = ImagePreviewController()
                
                imagePreview.imagePreviewView.imageView = UIImageView(image: uiImage)
                
                imagePreview.modalPresentationStyle = .formSheet
                self.present(imagePreview, animated: true)
                
            }
        case .objectDetection:
            print("object detection execute")
            let options = ObjectDetectorOptions()
            options.shouldEnableClassification = true
            //            options.shouldEnableMultipleObjects = true
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
                
                let points = strongSelf.convertedPoints(
                    from: block.cornerPoints, width: width, height: height)
                UIUtilities.addShape(
                    withPoints: points,
                    to: self.annotationOverlayView,
                    color: UIColor.black
                )
                
                // Lines.
                for line in block.lines {
                    let points = strongSelf.convertedPoints(
                        from: line.cornerPoints, width: width, height: height)
                    //            UIUtilities.addShape(
                    //              withPoints: points,
                    //              to: self.annotationOverlayView,
                    //              color: UIColor.white
                    //            )
                    
                    // Elements.
                    for element in line.elements {
                        let normalizedRect = CGRect(
                            x: element.frame.origin.x / width,
                            y: element.frame.origin.y / height,
                            width: element.frame.size.width / width,
                            height: element.frame.size.height / height
                        )
                        let convertedRect = strongSelf.cameraMainView.cameraView.preview.layerRectConverted(
                            fromMetadataOutputRect: normalizedRect
                        )
                        
                        UIUtilities.addRectangle(
                            convertedRect,
                            to: self.annotationOverlayView,
                            color: UIColor.white
                        )
                        let label = UILabel(frame: convertedRect)
                        label.text = element.text
                        label.adjustsFontSizeToFitWidth = true
                        strongSelf.annotationOverlayView.addSubview(label)
                    }
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
        let rotatedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        previewOverlayView.image = rotatedImage
        print(previewOverlayView.image?.imageOrientation.rawValue)
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
}
