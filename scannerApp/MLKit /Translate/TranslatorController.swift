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
    
    
    private let locale = Locale.current
    private var inputLanguage: LanguageModel!
    private var outputLanguage: LanguageModel!
    
    
    private init() {
        let userDefController = UserDefaultsController.userDefaultsInstance
        self.inputLanguage = userDefController.getLanguage(languageType: .input)
        self.outputLanguage = userDefController.getLanguage(languageType: .output)
    }
    
    
    func setLanguage(languageType: LanguageType, newValue: LanguageModel) {
        let userDefController = UserDefaultsController.userDefaultsInstance
        switch languageType {
        case .input:
            self.inputLanguage = newValue
            userDefController.setLanguage(languageType: .input, countryCode: newValue.languageCode!)
            
        case .output:
            self.outputLanguage = newValue
            userDefController.setLanguage(languageType: .output, countryCode: newValue.languageCode!)
        }
    }
    
    func getLanguage(languageType: LanguageType) -> LanguageModel {
        switch languageType {
        case .input:
            return inputLanguage
        case .output:
            return outputLanguage
        }
    }
    
    func translate(in text: String, callback: @escaping (_ text: String?) -> Void) {
        
        self.createLanguageOption(text: text, callback: { translatorOptions in
            
            let translator = Translator.translator(options: translatorOptions)
            let condition = ModelDownloadConditions(
                allowsCellularAccess: true, allowsBackgroundDownloading: true
            )
            translator.downloadModelIfNeeded(with: condition) { error in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                if translator == translator {
                    translator.translate(text) { result, error in
                        guard error == nil else {
                            print(error?.localizedDescription as Any)
                            return
                        }
                        if translator == translator {
                            callback(result)
                        }
                    }
                }
            }
        })
    }
    
    
    private func createLanguageOption(text: String, callback: @escaping (_ options: TranslatorOptions) -> Void) {

        if checkIsAutodetection() {
            let languageRecogUtil = LanguageRecognitionUtil.instance
            languageRecogUtil.identityLanguage(from: text, callback: { identLanguage in
                guard let recognizedLanguageCode = identLanguage?.first?.languageTag else {
                    print("error when recognise language")
                    return
                }
                let translatedLanguage = TranslateLanguage(rawValue: recognizedLanguageCode)
                
                print("recognised language \(self.locale.localizedString(forLanguageCode: translatedLanguage.rawValue) ?? "None"), translate to \(self.outputLanguage.displayName)")
                callback(TranslatorOptions(sourceLanguage: translatedLanguage, targetLanguage: self.outputLanguage.getTranslateLanguage()))
            })
        } else {
            print("recognised language \(self.inputLanguage.getTranslateLanguage().rawValue), translate to \(self.outputLanguage.getTranslateLanguage().rawValue)")
            callback(TranslatorOptions(sourceLanguage: self.inputLanguage.getTranslateLanguage(), targetLanguage: self.outputLanguage.getTranslateLanguage()))
        }
    }
    
    private func checkIsAutodetection() -> Bool {
        if self.inputLanguage.displayName == Constant.autodetectionIdentifier {
            return true
        }
        return false
    }
}



