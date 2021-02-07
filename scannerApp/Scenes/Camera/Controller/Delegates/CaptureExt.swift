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
        
        if !takePicture {
            return
        }
        
        guard var uiImage = self.getCapturedImage() else { return }
        
        
        DispatchQueue.main.sync {
            
            uiImage = UIUtilities.cropImage(uiImage,
                                toRect: self.cropBox.frame,
                                viewWidth: self.cameraMainView.cameraView.frame.width,
                                viewHeight: self.cameraMainView.cameraView.frame.height)

            let visionImage = VisionImage(image: uiImage)
            visionImage.orientation = uiImage.imageOrientation


            self.takePicture = false

            let imagePreview = ImagePreviewController()
            
            
            imagePreview.imagePreviewView.imageView.image = uiImage
            imagePreview.currentMode = self.currentMode
            imagePreview.imagePreviewView.currentMode = self.currentMode
            
            if self.currentMode == .translation {
                
                imagePreview.modalPresentationStyle = .formSheet
            } else {
                
                imagePreview.modalPresentationStyle = .custom
                imagePreview.transitioningDelegate = self
            }
            
            self.present(imagePreview, animated: true)
            
        }
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
