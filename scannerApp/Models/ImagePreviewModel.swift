//
//  ImagePreviewModel.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//

import Foundation
import UIKit
import MLKit

class ImagePreviewModel {
    private var text: String = ""
    private var translatedText: String = ""
    private var sourceLanguage: String = ""
    private var targetLanguage: String = ""
    private var time = Date()
    
    private var delegate: MLKitAction
    
    init(delegate: MLKitAction) {
        self.delegate = delegate
    }
    
    
    
    func process(image: UIImage, mode: CameraModes) {
        switch mode {
        case .objectDetection:
            self.processObjectDetection(image: image)
        case .landmarkDetection:
            self.processLandmarkDetection(image: image)
        case .translation:
            self.translate(image: image)
        case .imageLabeling:
            self.processImageLabeling(image: image)
        
        case .imgLblWithObjDet:

            let objectDetectionUtils = ObjectDetectionUtil()
            
            objectDetectionUtils.processObjectDetection(in: image, callback: { detectedObjects, error in
                if error != nil {
//                    self.delegate.imagePreviewModelTranslateWithError(self, error: error!)
                    self.processImageLabeling(image: image)
                } else {
                    guard let objects = detectedObjects else { return }

                    for object in objects {
                        
                        self.processImageLabeling(image: image)
                        self.delegate.addRectangle(rectangle: object.frame)

                    }
                    self.delegate.imagePreviewModelTranslateSuccessful(self)
                    
                }
            })
        }
    }
    
    //MARK: - Save to history
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


    //MARK: Object detection
    private func processObjectDetection(image: UIImage) {
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
                    self.translatedText += "|\n"
                    self.delegate.addRectangle(rectangle: object.frame)
                }
                self.delegate.imagePreviewModelTranslateSuccessful(self)
                
            }
        })
    }
    
    //MARK: Landmark detection
    private func processLandmarkDetection(image: UIImage) {
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
    }
    
    //MARK: Process image labeling
    private func processImageLabeling(image: UIImage) {
        let imageLabelingUtil = ImageLabelingUtil()
        
        imageLabelingUtil.processImageLabelingDetection(in: image, callback: { labels, error in
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
    
    

    
    //MARK: - Translate
    private func translate(image: UIImage) {
//        #warning("Cloud text recognition")
//        if true {
        if !Reachability.instance.connectionStatus {
            self.onDeviceTranslation(image: image)
        } else {
            self.cloudTranslation(image: image)
        }
    }
    
    private func onDeviceTranslation(image: UIImage) {
        let processor = ScaledElementProcessor()
        let translateController = TranslatorController.translatorInstance

        processor.processOnDeviceTextRecognise(in: image, callback: { text, error in
            
            guard let textResult = text else {
                self.delegate.imagePreviewModelTranslateWithError(self, error: TranslateError.textRecognitionError)
                return
            }
            
            
            for block in textResult.blocks {
                for line in block.lines {
                    translateController.translate(in: line.text, callback: { translatedLine, error in
                        if let error = error {
                            self.delegate.imagePreviewModelTranslateWithError(self, error: error)
                            return
                        }
                        guard let translatedLine = translatedLine else { return }
                        self.translatedText += translatedLine + "\n"
                        self.delegate.addRectangle(frame: line.frame, text: translatedLine)
                        self.delegate.imagePreviewModelTranslateSuccessful(self)
                    })
                }
            }
            self.text = textResult.text
        })
    }
    
    private func cloudTranslation(image: UIImage) {
        let processor = ScaledElementProcessor()
        let translateController = TranslatorController.translatorInstance

        processor.processCloudRecognition(in: image, callback: { text, error in
            
            guard let textResult = text else {
                self.delegate.imagePreviewModelTranslateWithError(self, error: TranslateError.textRecognitionError)
                return
            }

            for block in textResult.blocks {
                for line in block.lines {
                    translateController.translate(in: line.text, callback: { translatedLine, error in
                        if let error = error {
                            self.delegate.imagePreviewModelTranslateWithError(self, error: error)
                            return
                        }
                        guard let translatedLine = translatedLine else { return }
                        self.translatedText += translatedLine + "\n"
                        self.delegate.addRectangle(frame: line.frame, text: translatedLine)
                        self.delegate.imagePreviewModelTranslateSuccessful(self)
                    })
                }
            }
            self.text = textResult.text
        })
    }
}

