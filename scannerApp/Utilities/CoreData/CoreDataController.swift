//
//  CoreDataController.swift
//  Translate Camera
//
//  Created by Maksym on 27.12.2020.
//

import Foundation
import CoreData
import UIKit

class CoreDataController {
    
    func saveToHistory(historyModelStruct: HistoryModel) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchFromHistory() -> [HistoryModel] {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return  [HistoryModel]()
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryModel")
        request.returnsObjectsAsFaults = false
        var historyCell = [HistoryModel]()
        do {
            let result = try managedContext.fetch(request) as! [HistoryModel]
            historyCell = result
        } catch {
            print("failed fatching of history")
        }
        return historyCell
    }
    
    func deleteFromHistory(historyModel: HistoryModel) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(historyModel)
        
        do {
            try managedContext.save()
        } catch {
            print("delete failed")
        }
    }
}


class HistoryModelConstant {
    static let fromLanguage = "fromLanguage"
    static let text = "text"
    static let time = "time"
    static let toLanguage = "toLanguage"
    static let translatedText = "translatedText"
}
