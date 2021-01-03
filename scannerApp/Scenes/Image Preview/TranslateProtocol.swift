//
//  TranslateProtocol.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//

import Foundation
import MLKitTextRecognition


protocol TranslateProtocol: AnyObject {
    func imagePreviewModelTranslateSuccessful(_ imagePreviewModel: ImagePreviewModel)
    func imagePreviewModelTranslateWithError(_ imagePreviewModel: ImagePreviewModel, error: Error)
    func addRectangle(block: TextBlock)
}
