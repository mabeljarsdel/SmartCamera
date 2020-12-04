//
//  TranslatorController.swift
//  Translate Camera
//
//  Created by Maksym on 04.12.2020.
//

import Foundation
import UIKit
import MLKit


enum LanguageType {
    case input, output
}


class TranslatorController {
    static let translatorInstance = TranslatorController()
    
    
    let locale = Locale.current
    private var inputLanguage: TranslateLanguage!
    private var outputLanguage: TranslateLanguage!
    
    
    private init() {
        let userDefController = UserDefaultsController.userDefaultsInstance
        self.inputLanguage = userDefController.getLanguage(languageType: .input)
        self.outputLanguage = userDefController.getLanguage(languageType: .output)
    }
    
    
    func setLanguage(languageType: LanguageType, newValue: TranslateLanguage) {
        let userDefController = UserDefaultsController.userDefaultsInstance
        switch languageType {
        case .input:
            self.inputLanguage = newValue
            userDefController.setLanguage(languageType: .input, countryCode: newValue.rawValue)
            
        case .output:
            self.outputLanguage = newValue
            userDefController.setLanguage(languageType: .output, countryCode: newValue.rawValue)
        }
    }
    
    func getLanguage(languageType: LanguageType) -> TranslateLanguage {
        switch languageType {
        case .input:
            return inputLanguage
        case .output:
            return outputLanguage
        }
    }
}



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
