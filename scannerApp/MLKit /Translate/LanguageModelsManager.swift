//
//  LanguageModelsManage.swift
//  Translate Camera
//
//  Created by Maksym on 13.12.2020.
//

import Foundation
import MLKit

class LanguageModelsManager {
    let modelManager = ModelManager.modelManager()
    var downloading: TranslateLanguage?
    
    func isLanguageDownloaded(_ language: TranslateLanguage) -> Bool {
        let model = self.model(forLanguage: language)
        let modelManager = ModelManager.modelManager()
        return modelManager.isModelDownloaded(model)
    }
    
    func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel {
      return TranslateRemoteModel.translateRemoteModel(language: forLanguage)
    }
    
    func listDownloadedModels() -> String {
        return self.modelManager
            .downloadedTranslateModels.map { model in
                Locale.current.localizedString(forLanguageCode: model.language.rawValue)!
            }.joined(separator: ", ")
    }
    

    func handleDownloadDelete(language: TranslateLanguage, tag: Int) {
        let model = self.model(forLanguage: language)
        if self.isLanguageDownloaded(language) {
            modelManager.deleteDownloadedModel(model) { error in
                if let error = error {
                    print(error)
                } else {
                    
                    NotificationCenter.default.post(name: Notification.Name("ModelDeleted"), object: language)
                }
                
            }
        } else {
            
            let conditions = ModelDownloadConditions(
                allowsCellularAccess: true,
                allowsBackgroundDownloading: true
            )
            let process = modelManager.download(model, conditions: conditions)
            self.downloading = language
            NotificationCenter.default.post(name: Notification.Name("StartDownload"), object: language)
            
        }
    }
}
