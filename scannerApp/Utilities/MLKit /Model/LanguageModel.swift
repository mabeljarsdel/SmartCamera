//
//  LanguageModel.swift
//  Translate Camera
//
//  Created by Maksym on 20.12.2020.
//

import Foundation
import MLKit
import MLKitLanguageID




class LanguageModel: Equatable {
    private let translateLanguage: TranslateLanguage
    private var isDownloaded: Bool
    let languageCode: String
    let displayName: String
    
    init(translateLanguage: TranslateLanguage) {
        self.translateLanguage = translateLanguage
        self.languageCode = translateLanguage.rawValue
        self.displayName = Locale.current.localizedString(forLanguageCode: translateLanguage.rawValue) ?? Constant.autodetectionIdentifier
        self.isDownloaded = LanguageModelsManager.instance.isLanguageDownloaded(translateLanguage)
    }
    
    func getTranslateLanguage() -> TranslateLanguage {
        return self.translateLanguage
    }
    
    func getModelStatus() -> Bool {
        return self.isDownloaded
    }
    
    func changeModelStatus(newStatus: Bool) {
        self.isDownloaded = newStatus
    }
    
    static func ==(lhs: LanguageModel, rhs: LanguageModel) -> Bool {
        return lhs.languageCode == rhs.languageCode && lhs.displayName == rhs.displayName
    }
}



