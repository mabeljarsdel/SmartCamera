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
            //try and get a CVImageBuffer out of the sample buffer
            return //we have nothing to do with the image buffer
        }
        

        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer, options: [.applyOrientationProperty : true])
        guard let cgImage = ciImage.convertToCGImage() else { return }
        let uiImage = UIImage(cgImage: cgImage).rotate(radians: .pi/2)
        
        
        self.takePicture = false
        
        DispatchQueue.main.sync {
            let imagePreview = ImagePreview()
            imagePreview.imagePreviewView.imageView = UIImageView(image: uiImage)
            
            imagePreview.modalPresentationStyle = .formSheet
            self.present(imagePreview, animated: true)
            
        }
    }
    
    private func instantTranslate(image: UIImage) {
        let processor = ScaledElementProcessor()
        let imView = UIImageView(image: image)
        self.cameraMainView.cameraView.subviews.forEach({ $0.removeFromSuperview() })
        processor.process(in: imView, callback: { text, error in
            guard let textResult = text else { return }
            
            for block in textResult.blocks {
                for line in block.lines {
                    
                    let transformedRect = line.frame.applying(self.transformMatrix(imageView: imView))
                    self.addRectangle(transformedRect, to: self.cameraMainView.cameraView, color: .blue)
                }
            }
        })
    }
    
    public func addRectangle(_ rectangle: CGRect, to view: UIView, color: UIColor) {
        let rectangleView = UIView(frame: rectangle)
        rectangleView.layer.cornerRadius = 0
        rectangleView.alpha = 0.3
        rectangleView.backgroundColor = color
        view.addSubview(rectangleView)
    }
    
    private func transformMatrix(imageView: UIImageView) -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale =
            (imageViewAspectRatio > imageAspectRatio)
            ? imageViewHeight / imageHeight : imageViewWidth / imageWidth
        
        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
}

