//
//  ImagePreviewModel.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//

import Foundation
import UIKit

class ImagePreviewModel {
    var text: String = ""
    var translatedText: String = ""
    var sourceLanguage: String = ""
    var targetLanguage: String = ""
    var time = Date()
    
    var delegate: TranslateProtocol
    var currentMode: CameraModes
    
    init(delegate: TranslateProtocol, image: UIImageView, mode: CameraModes) {
        self.delegate = delegate
        self.currentMode = mode
        self.process(image: image)
    }
    
    

    func process(image: UIImageView) {
        switch self.currentMode {
        case .objectDetection:
            print("obj det")
            let objectDetectionUtils = ObjectDetectionUtil()
            objectDetectionUtils.processObjectDetection(in: image, callback: { detectedObjects, error in
                if error != nil {
                    self.delegate.imagePreviewModelTranslateWithError(self, error: error!)
                } else {
                    guard let objects = detectedObjects else { return }

                    for object in objects {
                        self.translatedText += "\(String(describing: object.trackingID))"
                        for label in object.labels {
                            self.translatedText += " \(label.text)"
                        }
                        self.translatedText += "\n"
                        self.delegate.addRectangle(rectangle: object.frame)
                    }
                    self.delegate.imagePreviewModelTranslateSuccessful(self)
                    
                }
            })
        case .landmarkDetection:
            print("land")
            let landmarkDetector = LandmarkDetectionUtil()
            
            landmarkDetector.processLandmarkDetection(in: image, callback: {  landmarksOpt, error in
                if error != nil {
                    self.delegate.imagePreviewModelTranslateWithError(self, error: error!)
                } else {
                    guard let landmarks = landmarksOpt else { return }
                    for landmark in landmarks {
                        self.translatedText += "\(landmark.landmark!)\n"
                        self.delegate.addRectangle(rectangle: landmark.frame)
                    }
                    self.delegate.imagePreviewModelTranslateSuccessful(self)
                    
                    print(self.translatedText)
                    
                }
            })

        case .translation:
            print("trranslation")
            self.translate(image: image)

        case .imageLabeling:
            print("image lableing")
            
            let imageLabelingUtil = ImageLabelingUtil()
            imageLabelingUtil.processLandmarkDetection(in: image, callback: { labels, error in
                if error != nil {
                    self.delegate.imagePreviewModelTranslateWithError(self, error: error!)
                } else {
                    guard let labels = labels else { return }
                    for label in labels {
                        self.translatedText += "\(label.text) \(Int(label.confidence*100))%\n"
                    }
                    
                    self.delegate.imagePreviewModelTranslateSuccessful(self)
                }
            })
        }
    }

    
    
    
    
    func saveToHistory() {
        let coreDataController = CoreDataController()
        let translateController = TranslatorController.translatorInstance

        let historyModel: HistoryModel = {
            if let appDelegate =
                UIApplication.shared.delegate as? AppDelegate {
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let hm = HistoryModel(context: managedContext)
                return hm
            } else {
                return HistoryModel()
            }
        }()
        
        historyModel.fromLanguage = translateController.getInputLanguage().rawValue
        historyModel.toLanguage = translateController.getOutputLanguage().rawValue
        historyModel.time = time
        historyModel.text = text
        historyModel.translatedText = translatedText
        
        coreDataController.saveToHistory(historyModelStruct: historyModel)
    }
    
    
    private func translate(image: UIImageView) {
        let processor = ScaledElementProcessor()
        let translateController = TranslatorController.translatorInstance
        #warning("Cloud text recognition")
//        if true {
        if !Reachability.instance.connectionStatus {
            processor.processOnDeviceTextRecognise(in: image, callback: { text, error in
                
                guard let textResult = text else {
                    self.delegate.imagePreviewModelTranslateWithError(self, error: TranslateError.textRecognitionError)
                    return
                }
                
                
                for block in textResult.blocks {
                    
                    translateController.translate(in: block.text, callback: { translatedText, error in
                        if let error = error {
                            self.delegate.imagePreviewModelTranslateWithError(self, error: error)
                            return
                        }
                        self.translatedText += (translatedText ?? "") + "\n"
                        self.delegate.imagePreviewModelTranslateSuccessful(self)

                    })
                    
                    self.delegate.addRectangle(block: block)
                }
                self.text = textResult.text
            })
        } else {
            processor.processCloudRecognition(in: image, callback: { text, error in
                
                guard let textResult = text else {
                    self.delegate.imagePreviewModelTranslateWithError(self, error: TranslateError.textRecognitionError)
                    return
                }
                
                
                for block in textResult.blocks {
                    
                    translateController.translate(in: block.text, callback: { translatedText, error in
                        if let error = error {
                            self.delegate.imagePreviewModelTranslateWithError(self, error: error)
                            return
                        }
                        self.translatedText += (translatedText ?? "") + "\n"
                        
                        self.delegate.imagePreviewModelTranslateSuccessful(self)
                    })
                    
                    self.delegate.addRectangle(block: block)
                }
                self.text = textResult.text
            })
        }
    }
}

