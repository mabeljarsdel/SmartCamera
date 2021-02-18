//
//  ObjectDetectionUtil.swift
//  Translate Camera
//
//  Created by Maksym on 16.01.2021.
//

import Foundation
import MLKit

class ObjectDetectionUtil {
    
        func processObjectDetection(in image: UIImage,
                                      callback: @escaping (_ text: [Object]?, Error?) -> Void) {
            


        let options = ObjectDetectorOptions()
            
        options.detectorMode = .singleImage
        options.shouldEnableMultipleObjects = true
        options.shouldEnableClassification = true

        let objectDetector = ObjectDetector.objectDetector(options: options)
        
        
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation

        objectDetector.process(visionImage, completion: { detectedObjects, error in
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


