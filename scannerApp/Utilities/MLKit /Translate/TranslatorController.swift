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
    private var inputLanguage: TranslateLanguage?
    private var outputLanguage: TranslateLanguage?
    
    func getInputLanguage() -> TranslateLanguage {
        return inputLanguage!
    }
    func getOutputLanguage() -> TranslateLanguage {
        return outputLanguage!
    }
    
    func translate(in text: String, callback: @escaping (_ text: String?, Error?) -> Void) {
        
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
                            callback(nil, TranslateError.translateError)
                            return
                        }
                        if translator == translator {
                            callback(result, nil)
                        }
                    }
                }
            }
        })
    }
    
    
    private func createLanguageOption(text: String, callback: @escaping (_ options: TranslatorOptions) -> Void) {
        let input = ChooseLanguageModel.instance.getLanguage(languageType: .input)
        let output = ChooseLanguageModel.instance.getLanguage(languageType: .output)

        if checkIsAutodetection() {
            let languageRecogUtil = LanguageRecognitionUtil.instance
            languageRecogUtil.identityLanguage(from: text, callback: { identLanguage, error in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let recognizedLanguageCode = identLanguage?.first?.languageTag else {
                    print("error when recognise language")
                    return
                }
                
                let translatedLanguage = TranslateLanguage(rawValue: recognizedLanguageCode)
                
                print("recognised language \(translatedLanguage.rawValue.languageName), translate to \(output.displayName)")
                self.inputLanguage = translatedLanguage
                self.outputLanguage = output.getTranslateLanguage()
                callback(TranslatorOptions(sourceLanguage: self.inputLanguage!, targetLanguage: self.outputLanguage!))
            })
        } else {
            print("recognised language \(input), translate to \(output)")
            self.inputLanguage = input.getTranslateLanguage()
            self.outputLanguage = output.getTranslateLanguage()
            callback(TranslatorOptions(sourceLanguage: self.inputLanguage!, targetLanguage: self.outputLanguage!))
        }
    }
    
    private func checkIsAutodetection() -> Bool {
        let chooseLanguageModel = ChooseLanguageModel.instance
        if chooseLanguageModel.getLanguage(languageType: .input).displayName == Constants.autodetectionIdentifier {
            return true
        }
        return false
    }
}



