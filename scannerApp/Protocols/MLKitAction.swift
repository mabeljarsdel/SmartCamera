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
    func addRectangle(textLine: TextLine, color: UIColor, text: String)
    func addRectangle(block: VisionTextBlock, color: UIColor)
    func addRectangle(rectangle: CGRect)
}
 
