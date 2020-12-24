//
//  LanguageModelsManage.swift
//  Translate Camera
//
//  Created by Maksym on 13.12.2020.
//

import Foundation
import MLKit

class LanguageModelsManager {
    static let instance = LanguageModelsManager()
    
    private init() {}
    
    let modelManager = ModelManager.modelManager()
    var downloading: LanguageModel?
    

    
    
    func isLanguageDownloaded(_ language: TranslateLanguage) -> Bool {
        let model = self.model(forLanguage: language)
        let modelManager = ModelManager.modelManager()
        return modelManager.isModelDownloaded(model)
    }
    
    private func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel {
      return TranslateRemoteModel.translateRemoteModel(language: forLanguage)
    }
    
    func handleDownloadDelete(language: LanguageModel, tag: Int) {
        let model = self.model(forLanguage: language.getTranslateLanguage())
        
        if language.getModelStatus() {
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
            let progress = modelManager.download(model, conditions: conditions)

            self.downloading = language
            NotificationCenter.default.post(name: Notification.Name("StartDownload"), object: language)
        }
    }
    
}
