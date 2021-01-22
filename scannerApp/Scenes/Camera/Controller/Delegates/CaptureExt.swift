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
        

        if !takePicture {

            return
        }
        
        connection.videoOrientation = .portrait
        lastFrame = sampleBuffer
        
        guard let uiImage = self.updatePreviewOverlayView() else { return }
        
        let visionImage = VisionImage(image: uiImage)
        visionImage.orientation = uiImage.imageOrientation


        self.takePicture = false
        
        DispatchQueue.main.sync {
            let imagePreview = ImagePreviewController()
            
            imagePreview.imagePreviewView.imageView.image = uiImage
            imagePreview.currentMode = self.currentMode
            
            imagePreview.modalPresentationStyle = .formSheet
            self.present(imagePreview, animated: true)
            
        }
        
        self.takePicture = false

    }

    private func updatePreviewOverlayView() -> UIImage? {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        let rotatedImage = UIImage(cgImage: cgImage)
        return rotatedImage
    }
    
//    private func removeDetectionAnnotations() {
//        for annotationView in annotationOverlayView.subviews {
//            annotationView.removeFromSuperview()
//        }
//    }
}
