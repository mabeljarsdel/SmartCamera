//
//  LanguageStore.swift
//  Translate Camera
//
//  Created by Maksym on 20.12.2020.
//

import Foundation
import MLKit


class LanguageStore {
    static var instance = LanguageStore()
    var languages: [LanguageModel] = {
        return TranslateLanguage.allLanguages()
            .map { lang in
                return LanguageModel(translateLanguage: lang, isDownloaded: LanguageModelsManager.instance.isLanguageDownloaded(lang))
            }.sorted {
                return $0.displayName < $1.displayName
            }
    }()
    
    private init() {}
}

