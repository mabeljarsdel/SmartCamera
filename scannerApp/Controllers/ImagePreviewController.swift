//
//  ImagePreview.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import Foundation
import MLKitTextRecognition
import MLKitVision
import UIKit
import Firebase



class ImagePreviewController: UIViewController {
    let imagePreviewView = ImagePreviewView()
    var imagePreviewModel: ImagePreviewModel?
    var currentMode: CameraModes
    
    var endWithError: Bool = true
    
    
    
    //MARK: View life cycle
    override func loadView() {
        super.loadView()
        self.view = imagePreviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePreviewModel = ImagePreviewModel(delegate: self, image: self.imagePreviewView.imageView, mode: self.currentMode)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.currentMode == .translation {
            if !self.endWithError {
                self.imagePreviewModel?.saveToHistory()
            }
        }
    }
    
    init(currentMode: CameraModes, image: UIImage) {
        self.currentMode = currentMode
        self.imagePreviewView.imageView = UIImageView(image: image)
        self.imagePreviewView.currentMode = currentMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OkAction".localized(withComment: ""), style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true)
        })
        self.endWithError = true
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

extension ImagePreviewController: TranslateProtocol {

    
    func imagePreviewModelTranslateSuccessful(_ imagePreviewModel: ImagePreviewModel) {
        self.imagePreviewView.activityIndicator.isHidden = true
        self.imagePreviewView.textView.text = imagePreviewModel.translatedText
        self.endWithError = false
    }
    
    func imagePreviewModelTranslateWithError(_ imagePreviewModel: ImagePreviewModel, error: Error) {
        self.imagePreviewView.activityIndicator.isHidden = true
        self.showAlert(title: "ErrorHeader".localized(withComment: ""), message: error.localizedDescription)
        print("translate with error")
    }
    
    func addRectangle(block: TextBlock) {
        for line in block.lines {
            let transformedRect = line.frame.applying(UIUtilities.transformMatrix(imageView: self.imagePreviewView.imageView))
            UIUtilities.addRectangle(transformedRect, to: self.imagePreviewView.imageView, color: .blue)
        }
    }
    
    func addRectangle(block: VisionTextBlock) {
        for line in block.lines {
            let transformedRect = line.frame.applying(UIUtilities.transformMatrix(imageView: self.imagePreviewView.imageView))
            UIUtilities.addRectangle(transformedRect, to: self.imagePreviewView.imageView, color: .blue)
            
        }
    }
    
    func addRectangle(rectangle: CGRect) {
        let transformedRect = rectangle.applying(UIUtilities.transformMatrix(imageView: self.imagePreviewView.imageView))
        UIUtilities.addRectangle(transformedRect, to: self.imagePreviewView.imageView, color: .blue)
    }
}



