//
//  Error.swift
//  Translate Camera
//
//  Created by Maksym on 10.01.2021.
//

import Foundation


enum TranslateError: Error {
    case textRecognitionError
    case languageRecognitionError
    case translateError
}

extension TranslateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .languageRecognitionError:
            return "LanguageNotRecognizedError".localized(withComment: "")
        case .textRecognitionError:
            return "TextNotRecognizedError".localized(withComment: "")
        case .translateError:
            return "TextNotTranslatedError".localized(withComment: "")
        }
    }
}


enum ObjectDetectionError: Error {
    case objectNotDetected
}

extension ObjectDetectionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .objectNotDetected:
            return "ObjectNotDetectedError".localized(withComment: "")
        }
    }
}

enum LandmarkDetectionError: Error {
    case landmarkNotDetected

}

extension LandmarkDetectionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .landmarkNotDetected:
            return "LandmarkNotDetectedError".localized(withComment: "")
        }
    }
}
