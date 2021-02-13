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

protocol TranslateProtocol: AnyObject {
    func imagePreviewModelTranslateSuccessful(_ imagePreviewModel: ImagePreviewModel)
    func imagePreviewModelTranslateWithError(_ imagePreviewModel: ImagePreviewModel, error: Error)
    func addRectangle(block: TextBlock)
    func addRectangle(block: VisionTextBlock)
    func addRectangle(rectangle: CGRect)
}
 
