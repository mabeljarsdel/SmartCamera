//
//  ScanDocumentsExtension.swift
//  Translate Camera
//
//  Created by Maksym on 11.12.2020.
//

import UIKit
import VisionKit

extension CameraViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("finish with")
        let image = scan.imageOfPage(at: 0)
        
        self.takePicture = false
        
        
        dismiss(animated: true, completion: nil)
        
        let imagePreview = ImagePreview()
        imagePreview.imageView = UIImageView(image: image)
        
        imagePreview.modalPresentationStyle = .formSheet
        self.present(imagePreview, animated: true)
        
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
}
