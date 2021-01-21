//
//  ImagePreviewView.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//

import Foundation
import UIKit


class ImagePreviewView: UIView {
    //MARK: View Components
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()
    
    let textView: UITextView = {
        
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        
        return tv
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        var ai = UIActivityIndicatorView(style: .large)
        ai.isHidden = true
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupConstaint()
        
    }
    
    
    func setupConstaint() {
        
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.center.equalTo(self.snp.center)
        }
        
        self.scrollView.addSubview(imageView)
        self.scrollView.addSubview(textView)
        
        imageView.snp.makeConstraints { make in
            
            let size = resizeRectangleForImage()
            
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
            
            make.top.equalTo(scrollView.snp.top).offset(20)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        
        
        textView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).offset(-30)
            make.topMargin.equalTo(imageView.snp.bottomMargin).offset(20)
            make.bottomMargin.equalTo(scrollView.snp.bottomMargin)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        
        self.scrollView.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).offset(-30)
            make.topMargin.equalTo(imageView.snp.bottomMargin).offset(50)
            make.bottomMargin.equalTo(scrollView.snp.bottomMargin)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        
        self.scrollView.backgroundColor = .systemBackground
    }
    
    func resizeRectangleForImage() -> CGSize {
        let defaultSize = CGSize(width: UIScreen.main.bounds.width-30, height: UIScreen.main.bounds.height*0.6)
        
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
