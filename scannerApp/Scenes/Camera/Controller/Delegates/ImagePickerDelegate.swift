//
//  ImagePickerDelegate.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import Foundation
import UIKit


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true)
        
        if let pickedImage = info[.originalImage] as? UIImage {
            let imagePreview = ImagePreview()
            imagePreview.imagePreviewView.imageView = UIImageView(image: pickedImage)
            
            imagePreview.modalPresentationStyle = .formSheet
            self.present(imagePreview, animated: true)
        }
    }
}
