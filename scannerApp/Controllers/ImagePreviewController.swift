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



class ImagePreviewController: UIViewController, UIGestureRecognizerDelegate {
    let imagePreviewView = ImagePreviewView()
    var imagePreviewModel: ImagePreviewModel?
    var currentMode: CameraModes
    
    var endWithError: Bool = true
    var defaultCenter: CGPoint!

    
    //MARK: View life cycle
    override func loadView() {
        super.loadView()
        self.view = imagePreviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePreviewModel = ImagePreviewModel(delegate: self)
        self.imagePreviewModel?.process(image: self.imagePreviewView.imageView.image!, mode: self.currentMode)
        self.setUpScaleGesture()
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
    

    
    func setUpScaleGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage(_:)))
        let dragImg = UIPanGestureRecognizer(target: self, action: #selector(dragImg(_:)))
        pinchGesture.delegate = self
        dragImg.delegate = self
        self.defaultCenter = self.imagePreviewView.imageView.center
        self.imagePreviewView.imageView.isUserInteractionEnabled = true
        self.imagePreviewView.imageView.addGestureRecognizer(pinchGesture)
//        self.imagePreviewView.imageView.addGestureRecognizer(dragImg)
    }
    
    //MARK: Show Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OkAction".localized(withComment: ""), style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true)
        })

        alert.addAction(ok)

        self.present(alert, animated: true)
    }
    
    
    //MARK: Gesture Action 
    @objc func dragImg(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        self.imagePreviewView.imageView.center = CGPoint(x: self.imagePreviewView.imageView.center.x + translation.x, y: self.imagePreviewView.imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if sender.state == .ended {
            self.imagePreviewView.imageView.center = defaultCenter
//            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc func scaleImage(_ sender: UIPinchGestureRecognizer) {
        
        self.imagePreviewView.imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        
        if sender.state == .ended {
            self.imagePreviewView.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}



//MARK:-Perform MLKit action protocol
extension ImagePreviewController: MLKitAction {

    
    func imagePreviewModelTranslateSuccessful(_ imagePreviewModel: ImagePreviewModel) {
        self.endWithError = false
        self.imagePreviewView.activityIndicator.isHidden = true
        self.imagePreviewView.textView.text = imagePreviewModel.getTranslatedText()
//        self.endWithError = false
    }
    
    func imagePreviewModelTranslateWithError(_ imagePreviewModel: ImagePreviewModel, error: Error) {
        self.imagePreviewView.activityIndicator.isHidden = true
        self.showAlert(title: "ErrorHeader".localized(withComment: ""), message: error.localizedDescription)
        print("translate with error")
    }
    
    func addRectangle(frame: CGRect, text: String) {
        let cropedImage = UIUtilities.cropImage(imagePreviewView.imageView.image!,
                                                toRect: frame,
                                                viewWidth: self.imagePreviewView.imageView.frame.width,
                                                viewHeight: self.imagePreviewView.imageView.frame.height)

        let transformedRect = frame.applying(UIUtilities.transformMatrix(imageView: self.imagePreviewView.imageView))
        let textColor = cropedImage.getColors()!.primary
        let backgroundColor = cropedImage.getColors()!.background
        UIUtilities.addLabel(transformedRect, to: self.imagePreviewView.imageView, text: text, backgroundColor: backgroundColor!, fontColor: textColor!)
    }

    
    func addRectangle(rectangle: CGRect) {
        let transformedRect = rectangle.applying(UIUtilities.transformMatrix(imageView: self.imagePreviewView.imageView))
        UIUtilities.addRectangle(transformedRect, to: self.imagePreviewView.imageView, color: .blue)
    }
}



