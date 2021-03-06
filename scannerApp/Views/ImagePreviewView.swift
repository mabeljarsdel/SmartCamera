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
    
    var currentMode: CameraModes!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if currentMode != .translation {
            self.setupConstraintSheet()
        } else {
            self.setupConstaint()
        }
    }
    
    func setupConstraintSheet() {
        self.addSubview(imageView)
        self.addSubview(textView)
        self.addSubview(activityIndicator)
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(10)
            make.top.equalTo(self.snp.top).offset(10)
            let rect = self.resizeRectangleForImageSheet()
            
            make.width.equalTo(rect.width)
            make.height.equalTo(rect.height)

        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.top.equalTo(self.snp.top).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)

            make.height.equalTo(imageView.snp.height)
            make.width.equalTo(self.frame.width*2/3)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(textView.snp.centerX)
            make.centerY.equalTo(textView.snp.centerY)
        }
        
        
        textView.font = textView.font?.withSize(14)
        
        self.backgroundColor = .systemBackground
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
//        self.scrollView.addSubview(textView)
        
        imageView.snp.makeConstraints { make in
            
            let size = resizeRectangleForImage()
            
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
            
            make.top.equalTo(scrollView.snp.top)
//                .offset(20)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        
        
//        textView.snp.makeConstraints { make in
//            make.width.equalTo(self.snp.width).offset(-30)
//            make.topMargin.equalTo(imageView.snp.bottomMargin).offset(20)
//            make.bottomMargin.equalTo(scrollView.snp.bottomMargin)
//            make.centerX.equalTo(scrollView.snp.centerX)
//        }
        
        imageView.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).offset(-30)
            make.topMargin.equalTo(imageView.snp.bottomMargin).offset(50)
            make.bottomMargin.equalTo(scrollView.snp.bottomMargin)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        
        self.scrollView.backgroundColor = .systemBackground
    }
    
    private func resizeRectangleForImageSheet() -> CGSize {
        let defaultSize = CGSize(width: self.frame.width/3, height: 300)
        
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
    
    private func resizeRectangleForImage() -> CGSize {
        let defaultSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
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
