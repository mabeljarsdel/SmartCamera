//
//  CaptureExt.swift
//  scannerApp
//
//  Created by Maksym on 03.12.2020.
//

import Foundation
import UIKit
import AVFoundation


extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
                
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        guard let cgImage = ciImage.convertToCGImage() else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        print(uiImage.imageOrientation.rawValue)
        
        self.takePicture = false
        DispatchQueue.main.sync {
            let imagePreview = ImagePreview()
            imagePreview.imageView = UIImageView(image: uiImage)
            
            imagePreview.modalPresentationStyle = .formSheet
            self.present(imagePreview, animated: true)
            
        }
    }
}

