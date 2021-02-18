//
//  CGRect.swift
//  Translate Camera
//
//  Created by Maksym on 18.02.2021.
//

import Foundation
import UIKit


extension CGRect {
    /// Returns a `Bool` indicating whether the rectangle's values are valid`.
    func isValid() -> Bool {
        return
            !(origin.x.isNaN || origin.y.isNaN || width.isNaN || height.isNaN || width < 0 || height < 0
                || origin.x < 0 || origin.y < 0)
    }
}
