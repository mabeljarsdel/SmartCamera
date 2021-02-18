//
//  LandmarkDetection.swift
//  Translate Camera
//
//  Created by Maksym on 22.01.2021.
//

import Foundation
import Firebase

class LandmarkDetectionUtil {
    func processLandmarkDetection(in image: UIImage,
                                      callback: @escaping (_ text: [VisionCloudLandmark]?, Error?) -> Void) {
        let options = VisionCloudDetectorOptions()
        options.modelType = .latest
        options.maxResults = 20
        
        
        let vision = Vision.vision()

        let cloudDetector = vision.cloudLandmarkDetector(options: options)

        let visionImage = VisionImage(image: image)
        
        cloudDetector.detect(in: visionImage, completion: { landmark, error in
            if error != nil {
                print(error?.localizedDescription ?? "Landmark detection error")
                callback(nil, error)
            } else {
                if landmark?.count == 0 {
                    callback(nil, LandmarkDetectionError.landmarkNotDetected)
                }
                callback(landmark, nil)
            }
        })
    }
}


