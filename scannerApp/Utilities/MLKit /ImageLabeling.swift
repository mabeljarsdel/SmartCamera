//
//  ImageLabeling.swift
//  Translate Camera
//
//  Created by Maksym on 22.01.2021.
//

import Foundation
import MLKit
import UIKit

class ImageLabelingUtil {
    
    func processImageLabelingDetection(in image: UIImage,
                                  callback: @escaping (_ label: [ImageLabel]?, Error?) -> Void) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        let options = ImageLabelerOptions()
        
        
        let labeler = ImageLabeler.imageLabeler(options: options)
        
        labeler.process(visionImage, completion: { labels, error in
            if error != nil {
                print(error?.localizedDescription ?? "Image lebeling error")
                callback(nil, error)
            } else {
                if labels?.count == 0 {
                    callback(nil, ObjectDetectionError.objectNotDetected)
                }
                callback(labels, nil)
            }
        })
    }
}
