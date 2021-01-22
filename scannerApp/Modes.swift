//
//  Modes.swift
//  Translate Camera
//
//  Created by Maksym on 22.01.2021.
//

import Foundation



enum CameraModes: CustomStringConvertible, CaseIterable {
    case objectDetection
    case landmarkDetection
    case normal
    case translation
    case imageLabeling
    
    var description: String {
        switch self {
        case .objectDetection: return "Object detection"
        case .landmarkDetection: return "Landmark detection"
        case .normal: return "Normal"
        case .translation: return "Translation"
        case .imageLabeling: return "Image labeling"
        }
    }
}
