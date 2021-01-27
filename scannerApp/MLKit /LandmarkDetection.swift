//
//  LandmarkDetection.swift
//  Translate Camera
//
//  Created by Maksym on 22.01.2021.
//

import Foundation
import Firebase

class LandmarkDetectionUtil {
    func processLandmarkDetection(in imageView: UIImageView,
                                      callback: @escaping (_ text: [VisionCloudLandmark]?, Error?) -> Void) {
        let options = VisionCloudDetectorOptions()
        options.modelType = .latest
        options.maxResults = 20
        
        
        let vision = Vision.vision()

        let cloudDetector = vision.cloudLandmarkDetector(options: options)

        let image = VisionImage(image: imageView.image!)
        
        cloudDetector.detect(in: image, completion: { landmark, error in
            if error != nil {
                print(error?.localizedDescription)
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


