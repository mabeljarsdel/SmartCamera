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
    var translator: Translator?
    
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
    
    func translate(in text: String, callback: @escaping (_ text: String?) -> Void) {
        let options = TranslatorOptions(sourceLanguage: inputLanguage, targetLanguage: outputLanguage)
        translator = Translator.translator(options: options)
        
        //MARK: Implement packet manager
        
        let translatorForDownloading = self.translator!

        translatorForDownloading.downloadModelIfNeeded { error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            if translatorForDownloading == self.translator {
                translatorForDownloading.translate(text) { result, error in
                    guard error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    if translatorForDownloading == self.translator {
                        callback(result)
                    }
                }
            }
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

