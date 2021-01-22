//
//  ObjectDetectionUtil.swift
//  Translate Camera
//
//  Created by Maksym on 16.01.2021.
//

import Foundation
import MLKit

class ObjectDetectionUtil {
    var delegate: ObjectDetectionDelegate?
    
    func processObjectDetection(in imageView: UIImageView,
                                      callback: @escaping (_ text: [Object]?, Error?) -> Void) {
        
        // Multiple object detection in static images
        let options = ObjectDetectorOptions()
        options.detectorMode = .singleImage
        options.shouldEnableMultipleObjects = true
        options.shouldEnableClassification = true
        

        // Or, to change the default settings:
        let objectDetector = ObjectDetector.objectDetector(options: options)
        
        
        let image = VisionImage(image: imageView.image!)
        image.orientation = imageView.image!.imageOrientation

        objectDetector.process(image, completion: { detectedObjects, error in
            if error != nil {
                print(error)
                callback(nil, error)
            } else {
                callback(detectedObjects, nil)
            }
        })
    }
//
//    func detectObjectOnDevice(in image: VisionImage,
//                              width: CGFloat,
//                              height: CGFloat,
//                              options: CommonObjectDetectorOptions
//                              ) {
//        let detector = ObjectDetector.objectDetector(options: options)
//        var objects: [Object]
//        do {
//            objects = try detector.results(in: image)
//        } catch let error {
//            print("Failed to detect objects with error: \(error.localizedDescription).")
//            return
//        }
//
//        DispatchQueue.main.sync {
//            guard !objects.isEmpty else {
//                print("On-Device object detector returned no results.")
//                      return
//            }
//
//            for object in objects {
//                let normalizedrect = CGRect(
//                    x: object.frame.origin.x / width,
//                    y: object.frame.origin.y / height,
//                    width: object.frame.size.width / width,
//                    height: object.frame.size.height / height
//                )
//
//                let label = UILabel(frame: normalizedrect)
//
//                var description = ""
//                if let trackingID = object.trackingID {
//                    description += "Object ID: " + trackingID.stringValue + "\n"
//                }
//                description += object.labels.enumerated().map { (index, label) in
//                    "Label \(index): \(label.text), \(label.confidence), \(label.index)"
//                }.joined(separator: "\n")
//
//                print(description)
//
//            }
//        }
//    }
}


protocol ObjectDetectionDelegate {
    func addLabel(label: UILabel)
}
