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
import UIDrawer
import QCropper

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        connection.videoOrientation = .portrait
        lastFrame = sampleBuffer
        //            self.updatePreviewOverlayView()
        
        
        if !takePicture {
            return
        }
        
        guard let uiImage = self.getCapturedImage() else { return }
        
        let visionImage = VisionImage(image: uiImage)
        visionImage.orientation = uiImage.imageOrientation


        self.takePicture = false
        
        DispatchQueue.main.sync {
            if self.currentMode == .translation {
                let imagePreview = ImagePreviewController()
                
                imagePreview.imagePreviewView.imageView.image = uiImage
                imagePreview.currentMode = self.currentMode
                imagePreview.imagePreviewView.currentMode = self.currentMode

                
                imagePreview.modalPresentationStyle = .formSheet
                self.present(imagePreview, animated: true)
            } else {
                let imagePreview = ImagePreviewController()
                
                
                imagePreview.imagePreviewView.imageView.image = uiImage
                imagePreview.imagePreviewView.currentMode = self.currentMode

                imagePreview.currentMode = self.currentMode
                
                imagePreview.modalPresentationStyle = .custom
                imagePreview.transitioningDelegate = self
                self.present(imagePreview, animated: true)
            }
            

            
        }
        
        self.takePicture = false

    }

    private func getCapturedImage() -> UIImage? {
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
        
        self.previewOverlayView.image = rotatedImage
        

    }
}

extension CameraViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DrawerPresentationController(presentedViewController: presented, presenting: presenting)

        presentationController.cornerRadius = 20
        presentationController.roundedCorners = [.topLeft, .topRight]
        presentationController.topGap = 240
        presentationController.bounce = true
        return presentationController
     }
}
