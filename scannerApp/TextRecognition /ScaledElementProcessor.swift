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



class ScaledElementProcessor {

    var textRecognizer: TextRecognizer


    init() {
        self.textRecognizer = TextRecognizer.textRecognizer()

    }

    func process(in imageView: UIImageView,
                 callback: @escaping (_ text: Text?) -> Void) {

        guard let image = imageView.image else { return }
        

        let visionImage = VisionImage(image: image)
        
        visionImage.orientation = image.imageOrientation
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil,
                let result = result,
                !result.text.isEmpty
            else {
                return
            }
            callback(result)
        }
    }
}
