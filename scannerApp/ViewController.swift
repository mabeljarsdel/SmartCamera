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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraView = CameraView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight))
        cameraView.center = self.view.center

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                
                self.view.addSubview(cameraView)

            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.view.addSubview(cameraView)
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        }
        
        
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

