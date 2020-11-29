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
    
    
    var imageView: UIImageView?
    var textView: UITextView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Open Camera", for: .normal)
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false

        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            
        
        let textView = UITextView(frame: CGRect(x: 20.0, y: 30.0, width: 300.0, height: 30.0))
        textView.textAlignment = NSTextAlignment.center
        textView.isUserInteractionEnabled = false
        
        
        self.view.addSubview(textView)
        
        
        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth-60).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        textView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20).isActive = true
        self.textView = textView
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
    @objc func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let processor = ScaledElementProcessor()
            
            if self.imageView != nil {
                self.imageView?.image = nil 
            }
            
            let image = UIImageView(image: pickedImage.jpeg(.low))
            self.imageView = image
            self.imageView!.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: 300)
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.center = CGPoint(x: view.center.x, y: view.center.y - 100)
            view.addSubview(imageView!)
            
            
            

            self.view.addSubview(image)
            self.textView!.text = ""
            processor.process(in: image, callback: { text in
                self.textView!.text += " \(text)"
            })
        }
        self.dismiss(animated: true)
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
