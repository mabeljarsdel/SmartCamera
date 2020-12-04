//
//  ImagePreview.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import Foundation
import UIKit
import AVFoundation



class ImagePreview: UIViewController {
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()
    
    var textView: UITextView = {
        
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpConstaint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.recogniseTextFromImage()
    }
    
    private func recogniseTextFromImage() {
        let processor = ScaledElementProcessor()
        self.textView.text = ""
        processor.process(in: self.imageView, callback: { text in
            
            guard let textResult = text else { return }
            
            for block in textResult.blocks {
                
                for line in block.lines {
                    
                    self.textView.text += "\(line.text)\n"
                    
                    let transformedRect = line.frame.applying(self.transformMatrix())
                    self.addRectangle(transformedRect, to: self.imageView, color: .blue)
                    
                }
            }
        })
    }
}


extension ImagePreview {
    func setUpConstaint() {
        
        self.view.addSubview(imageView)
        self.view.addSubview(textView)
        
        
        imageView.snp.makeConstraints { make in
            
            let size = resizeRectangleForImage()
            
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
            
            make.top.equalTo(view.snp.top).offset(20)
            make.centerX.equalTo(view.center.x)
        }
        
        
        
        textView.snp.makeConstraints { make in
            make.width.height.equalTo(UIScreen.main.bounds.width-20)
            make.topMargin.equalTo(imageView.snp.bottomMargin)
            make.centerX.equalTo(view.center.x)
        }
        
        self.view.backgroundColor = .white
        
    }
    
    public func addRectangle(_ rectangle: CGRect, to view: UIView, color: UIColor) {
        let rectangleView = UIView(frame: rectangle)
        rectangleView.layer.cornerRadius = 0
        rectangleView.alpha = 0.3
        rectangleView.backgroundColor = color
        view.addSubview(rectangleView)
    }
    
    private func transformMatrix() -> CGAffineTransform {
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
    
    func resizeRectangleForImage() -> CGSize {
        let defaultSize = CGSize(width: UIScreen.screenSize.width-30, height: UIScreen.screenSize.height*0.7)
        
        
        let ratio = self.imageView.image!.size.width/self.imageView.image!.size.height
        
        if ratio > 1 {
            let newHeight = defaultSize.width / ratio
            return CGSize(width: defaultSize.width, height: newHeight)
        } else {
            if (defaultSize.width / ratio) > defaultSize.height {
                let newWidth = defaultSize.height * ratio
                
                return CGSize(width: newWidth, height: defaultSize.height)
            } else {
                let newHeight = defaultSize.width / ratio
                
                return CGSize(width: defaultSize.width, height: newHeight)
            }
        }
    }
}