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




    func processOnDeviceTextRecognise(in image: UIImage,
                                      callback: @escaping (_ text: Text?, Error?) -> Void) {

        let textRecognizer = TextRecognizer.textRecognizer()


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
    
    
    
    func processCloudRecognition(in image: UIImage,
                 callback: @escaping (_ text: VisionText?, Error?) -> Void) {
        
        
        let vision = Vision.vision()
        let textRecognizer = vision.cloudTextRecognizer()


        
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
