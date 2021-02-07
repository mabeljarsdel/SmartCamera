//
//  ScaledElementProcessor.swift
//  scannerApp
//
//  Created by Maksym on 29.11.2020.
//

import Foundation
import MLKitTextRecognition
import MLKitVision
import UIKit
import Firebase

class ScaledElementProcessor {

    var textRecognizer: TextRecognizer


    init() {
        self.textRecognizer = TextRecognizer.textRecognizer()

    }
    
    func processOnDeviceTextRecognise(in imageView: UIImageView,
                                      callback: @escaping (_ text: Text?, Error?) -> Void) {

        print("Process in device text recognise")
        
        guard let image = imageView.image else { return }
        

        let visionImage = MLKitVision.VisionImage(image: image)
        
        visionImage.orientation = image.imageOrientation
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil,
                let result = result,
                !result.text.isEmpty
            else {
                callback(nil, TranslateError.textRecognitionError)
                return
            }
            callback(result, nil)
        }
    }
    
    
    
    func processCloudRecognition(in imageView: UIImageView,
                 callback: @escaping (_ text: VisionText?, Error?) -> Void) {
        
        print("Process cloud text recognise")
        
        let vision = Vision.vision()
        let textRecognizer = vision.cloudTextRecognizer()

        guard let image = imageView.image else { return }

        
        let visionImage = FirebaseMLVision.VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil,
                let result = result,
                !result.text.isEmpty
            else {
                if let error = error {
                    print(error.localizedDescription)
                    callback(nil, TranslateError.translateError)
                }
                return
            }
            callback(result, nil)
        }
    }
}