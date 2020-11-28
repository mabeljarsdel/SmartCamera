//
//  ViewController.swift
//  scannerApp
//
//  Created by Maksym on 29.11.2020.
//

import UIKit
import AVFoundation
import Firebase

class ScaledElementProcessor {
    
    
    let vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    
    init() {
        self.textRecognizer = vision.onDeviceTextRecognizer()

    }
    
    func process(in imageView: UIImageView,
                 callback: @escaping (_ text: String) -> Void) {

        guard let image = imageView.image else { return }
        
        
        let visionImage = VisionImage(image: image)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil,
                let result = result,
                !result.text.isEmpty
            else {
                callback("")
                return
            }
            callback(result.text)
        }
    }
}

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let processor = ScaledElementProcessor()
        processor.process(in: UIImageView(image: UIImage(named: "test_image_1")), callback: { text in
            print(text)
        })
        
        processor.process(in: UIImageView(image: UIImage(named: "test_image_2")), callback: { text in
            print(text)
        })
        
    }
    
    
}

