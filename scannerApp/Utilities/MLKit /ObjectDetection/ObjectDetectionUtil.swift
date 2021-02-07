//
//  ObjectDetectionUtil.swift
//  Translate Camera
//
//  Created by Maksym on 16.01.2021.
//

import Foundation
import MLKit

class ObjectDetectionUtil {
    
        func processObjectDetection(in imageView: UIImageView,
                                      callback: @escaping (_ text: [Object]?, Error?) -> Void) {
            


        let options = ObjectDetectorOptions()
            
        options.detectorMode = .singleImage
        options.shouldEnableMultipleObjects = true
        options.shouldEnableClassification = true

        let objectDetector = ObjectDetector.objectDetector(options: options)
        
        
        let image = VisionImage(image: imageView.image!)
        image.orientation = imageView.image!.imageOrientation

        objectDetector.process(image, completion: { detectedObjects, error in
            if error != nil {
                print(error ?? "Object detection error")
                callback(nil, error)
            } else {
                if detectedObjects?.count == 0 {
                    callback(nil, ObjectDetectionError.objectNotDetected)
                }
                callback(detectedObjects, nil)
            }
        })
    }
}


