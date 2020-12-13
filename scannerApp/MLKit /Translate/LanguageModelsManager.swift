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
    
    func deleteLanguage(language: TranslateLanguage) {
        let model = self.model(forLanguage: language)
        if modelManager.isModelDownloaded(model) {
            modelManager.deleteDownloadedModel(model) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func downloadLanguage(language: TranslateLanguage) {
        let languageTranslateModel = TranslateRemoteModel.translateRemoteModel(language: language)
        let progress = modelManager.download(languageTranslateModel, conditions: ModelDownloadConditions(
                allowsCellularAccess: false,
                allowsBackgroundDownloading: true
        ))
        progress.resume()
    }
    
    @objc func remoteModelDownloadDidComplete(notificaiton: NSNotification) {
        let userInfo = notificaiton.userInfo!
        guard let remoteModel = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel
        else {
            return
        }
        let languageName = Locale.current.localizedString(
            forLanguageCode: remoteModel.language.rawValue)!
        DispatchQueue.main.async {
            print(languageName)
            if notificaiton.name == .mlkitModelDownloadDidSucceed {
                print("Success")
            } else {
                print("Download failed")
            }
        }
    }
    
    
    func handleDownloadDelete(language: TranslateLanguage) {
        
    }
}
