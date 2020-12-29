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
    
    func saveToHistory(historyModelStruct: HistoryModelStruct) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "HistoryModel", in: managedContext)
        
        let history = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        history.setValue(historyModelStruct.fromLanguage, forKey: HistoryModelConstant.fromLanguage)
        history.setValue(historyModelStruct.toLanguage, forKey: HistoryModelConstant.toLanguage)
        history.setValue(Date(), forKey: HistoryModelConstant.time)
        history.setValue(historyModelStruct.text, forKey: HistoryModelConstant.text)
        history.setValue(historyModelStruct.translatedText, forKey: HistoryModelConstant.translatedText)
        
        do {
            try managedContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchFromHistory() -> [NSManagedObject] {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return  [NSManagedObject]()
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryModel")
        request.returnsObjectsAsFaults = false
        var historyCell = [NSManagedObject]()
        do {
            let result = try managedContext.fetch(request) as! [NSManagedObject]
            historyCell = result
        } catch {
            print("failed fatching of history")
        }
        return historyCell
    }
}

struct HistoryModelStruct {
    var fromLanguage: String = ""
    var toLanguage: String = ""
    var text: String = ""
    var translatedText: String = ""
}

class HistoryModelConstant {
    static let fromLanguage = "fromLanguage"
    static let text = "text"
    static let time = "time"
    static let toLanguage = "toLanguage"
    static let translatedText = "translatedText"
}
