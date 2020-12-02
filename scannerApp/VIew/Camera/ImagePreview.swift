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
    
    var imageView: UIImageView!
    var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            
            make.width.equalTo(UIScreen.main.bounds.width-20)
            make.height.equalTo(((UIScreen.main.bounds.width-60)/3)*4)
            make.top.equalTo(view.snp.top).offset(10)
            make.centerX.equalTo(view.center.x)
        }
        
        self.textView = UITextView()
        self.textView.text = "Waitng.."
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        
        textView.snp.makeConstraints { make in
            make.width.height.equalTo(UIScreen.main.bounds.width-20)
            make.topMargin.equalTo(imageView.snp.bottomMargin)
            make.centerX.equalTo(view.center.x)
        
        }
        
    
        
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let processor = ScaledElementProcessor()
        self.textView.text = ""
        if self.imageView != nil {
            processor.process(in: self.imageView, callback: { text in
                guard let textResult = text else { return }
                for block in textResult.blocks {
                    for line in block.lines {
                        self.textView!.text += "\(line.text)\n"
                        print(block.frame)
                        let transformedRect = line.frame.applying(self.transformMatrix())
                        self.addRectangle(transformedRect, to: self.imageView, color: .blue)
                        
                    }
                }
            })
        }
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
}
