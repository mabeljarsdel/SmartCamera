//
//  TranslateProtocol.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//


import Foundation
import MLKitTextRecognition
import MLKitVision
import UIKit
import Firebase

protocol MLKitAction: AnyObject {
    func imagePreviewModelTranslateSuccessful(_ imagePreviewModel: ImagePreviewModel)
    func imagePreviewModelTranslateWithError(_ imagePreviewModel: ImagePreviewModel, error: Error)
    func addRectangle(frame: CGRect, text: String)
//    func addRectangle(text: VisionTextLine, text: String)
    func addRectangle(rectangle: CGRect)
}
 
