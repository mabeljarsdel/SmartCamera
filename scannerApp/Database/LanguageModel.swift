//
//  LanguageModel.swift
//  Translate Camera
//
//  Created by Maksym on 20.12.2020.
//

import Foundation
import MLKit


class LanguageModel {
    private let translateLanguage: TranslateLanguage
    private var isDownloaded: Bool
    let languageCode: String?
    let displayName: String
    
    init(translateLanguage: TranslateLanguage, isDownloaded: Bool) {
        self.translateLanguage = translateLanguage
        self.languageCode = translateLanguage.rawValue
        self.displayName = Locale.current.localizedString(forLanguageCode: translateLanguage.rawValue) ?? "Autodetection"
        self.isDownloaded = isDownloaded
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
}
