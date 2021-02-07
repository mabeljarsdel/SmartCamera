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
    case translation
    case imageLabeling
    case imgLblWithObjDet
    
    var description: String {
        switch self {
        case .objectDetection: return "ObjectDetection".localized(withComment: "")
        case .landmarkDetection: return "LandmarkDetection".localized(withComment: "")
        case .translation: return "Translation".localized(withComment: "")
        case .imageLabeling: return "ImageLabeling".localized(withComment: "")
        case .imgLblWithObjDet: return "Img lbl + obj det"
        }
    }
}
