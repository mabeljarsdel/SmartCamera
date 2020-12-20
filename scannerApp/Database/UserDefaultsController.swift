//
//  UserDefaultsController.swift
//  Translate Camera
//
//  Created by Maksym on 20.12.2020.
//

import Foundation
import UIKit
import MLKit



class UserDefaultsController {
    static let userDefaultsInstance = UserDefaultsController()
    private var inputLangKey = "inputLanguage"
    private var outputLangKey = "outputLanguage"
    private var userDefaultsInstance = UserDefaults.standard
    
    func getLanguage(languageType: LanguageType) -> TranslateLanguage {
        var langCode: String
        switch languageType {
        case .input:
            langCode = userDefaultsInstance.string(forKey: inputLangKey) ?? "en"
            
        case .output:
            langCode = userDefaultsInstance.string(forKey: outputLangKey) ?? "es"
        }
        
        return TranslateLanguage(rawValue: langCode)
    }
    
    func setLanguage(languageType: LanguageType, countryCode: String) {
        switch languageType {
        case .input:
            userDefaultsInstance.setValue(countryCode, forKey: inputLangKey)
        case .output:
            userDefaultsInstance.setValue(countryCode, forKey: outputLangKey)
        }
    }
}

