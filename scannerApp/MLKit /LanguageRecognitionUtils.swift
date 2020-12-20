//
//  LanguageRecognitionUtils.swift
//  Translate Camera
//
//  Created by Maksym on 20.12.2020.
//

import Foundation
import MLKitLanguageID
import MLKit

class LanguageRecognitionUtil {
    var languageId = LanguageIdentification.languageIdentification()
    static var instance = LanguageRecognitionUtil()
    
    private init() {}
    
    func identityLanguage(from text: String, callback: @escaping (_ language: [IdentifiedLanguage]?) -> Void)  {
        languageId.identifyPossibleLanguages(for: text) { (identifiedlanguages, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            callback(identifiedlanguages)
        }
    }
}
