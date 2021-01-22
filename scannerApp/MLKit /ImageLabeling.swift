//
//  ImageLabeling.swift
//  Translate Camera
//
//  Created by Maksym on 22.01.2021.
//

import Foundation
import MLKit
class ImageLabelingUtil {
    
    func processLandmarkDetection(in imageView: UIImageView,
                                  callback: @escaping (_ text: [ImageLabel]?, Error?) -> Void) {
        let image = MLKit.VisionImage(image: imageView.image!)
        image.orientation = imageView.image!.imageOrientation
        
        
        let options = ImageLabelerOptions()

        let labeler = ImageLabeler.imageLabeler(options: options)
        
        labeler.process(image, completion: { labels, error in
            if error != nil {
                print(error?.localizedDescription)
                callback(nil, error)
            } else {
                callback(labels, nil)
            }
        })
        
    }
}
