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
            return NSLocalizedString("Language not recognized", comment: "Language not recognized")
        case .textRecognitionError:
            return NSLocalizedString("Text not recognized", comment: "Text not recognized")
        case .translateError:
            return NSLocalizedString("Text not translated", comment: "Text not translated")
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
            return NSLocalizedString("Object not detected", comment: "Object not detected")
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
            return NSLocalizedString("Landmark not detected", comment: "Landmark not detected")
        }
    }
}
