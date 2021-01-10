//
//  ImagePreview.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import Foundation
import UIKit
import AVFoundation
import MLKitTextRecognition


class ImagePreview: UIViewController {
    let imagePreviewView = ImagePreviewView()
    var imagePreviewModel: ImagePreviewModel?
    
    //MARK: View life cycle
    override func loadView() {
        super.loadView()
        self.view = imagePreviewView

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePreviewModel = ImagePreviewModel(delegate: self, image: self.imagePreviewView.imageView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.imagePreviewModel?.saveToHistory()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok tapped")
            self.dismiss(animated: true)
        })
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

extension ImagePreview: TranslateProtocol {
    func imagePreviewModelTranslateSuccessful(_ imagePreviewModel: ImagePreviewModel) {
        self.imagePreviewView.activityIndicator.isHidden = true
        self.imagePreviewView.textView.text = imagePreviewModel.translatedText

    }
    
    func imagePreviewModelTranslateWithError(_ imagePreviewModel: ImagePreviewModel, error: Error) {
        self.imagePreviewView.activityIndicator.isHidden = true
        self.showAlert(title: "Something goes wrong", message: error.localizedDescription)
        print("translate with error")
    }
    
    func addRectangle(block: TextBlock) {
        for line in block.lines {
            let transformedRect = line.frame.applying(AddRectangleToImageHelper.transformMatrix(imageView: self.imagePreviewView.imageView))
            AddRectangleToImageHelper.addRectangle(transformedRect, to: self.imagePreviewView.imageView, color: .blue)
        }
    }
}



