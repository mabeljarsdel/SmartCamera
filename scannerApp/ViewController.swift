//
//  ViewController.swift
//  scannerApp
//
//  Created by Maksym on 29.11.2020.
//

import UIKit
import AVFoundation
import Firebase

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.openCamera()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
//        let processor = ScaledElementProcessor()
//        processor.process(in: UIImageView(image: UIImage(named: "test_image_1")), callback: { text in
//            print(text)
//        })
//
//        processor.process(in: UIImageView(image: UIImage(named: "test_image_2")), callback: { text in
//            print(text)
//        })
//
    }
    

}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.videoQuality = .typeLow
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let processor = ScaledElementProcessor()
            
            processor.process(in: UIImageView(image: pickedImage.jpeg(.medium)), callback: { text in
                print(text)
            })
        }
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> UIImage? {
        return  UIImage(data: jpegData(compressionQuality: jpegQuality.rawValue)!)
    }
}
