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
            return NSLocalizedString("Language doesnt recognised", comment: "Language recognition error")
        case .textRecognitionError:
            return NSLocalizedString("Text doesnt recognised", comment: "Text recognition error")
        case .translateError:
            return NSLocalizedString("Text doesnt translated", comment: "Translate error")
        }
    }
}
