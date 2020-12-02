//
//  CGImage.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import Foundation
import UIKit

extension CIImage {
    func convertToCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let convertedCgImage = context.createCGImage(self, from: self.extent) {
            return convertedCgImage
        }
        return nil
    }
}
