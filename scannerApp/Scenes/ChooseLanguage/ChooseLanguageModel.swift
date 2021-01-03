//
//  ChooseLanguageModel.swift
//  Translate Camera
//
//  Created by Maksym on 30.12.2020.
//

import Foundation


class ChooseLanguageModel {
    static let instance = ChooseLanguageModel()

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
            userDefController.setLanguage(languageType: .input, countryCode: newValue.languageCode)
            
        case .output:
            self.outputLanguage = newValue
            userDefController.setLanguage(languageType: .output, countryCode: newValue.languageCode)
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

}
