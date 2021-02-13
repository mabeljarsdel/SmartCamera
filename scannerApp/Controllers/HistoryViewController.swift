//
//  HistoryView.swift
//  Translate Camera
//
//  Created by Maksym on 26.12.2020.
//

import Foundation
import UIKit
import CoreData

class HistoryViewController: UIViewController {

    var historyView: HistoryView!
    
    var historyCells: [HistoryModel] = []
    var filteredHistory: [HistoryModel] = []
    
    override func loadView() {
        super.loadView()
        self.historyView = HistoryView()
        self.view = historyView

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let coreDataController = CoreDataController()
        self.historyCells = coreDataController.fetchFromHistory()
        self.historyCells.sort(by: { $0.time! > $1.time! })
        self.filteredHistory = self.historyCells
        
        self.setupView()

    }
    
    func setupView() {
        self.historyView.searchController.delegate = self
        self.historyView.searchController.searchResultsUpdater = self
        self.historyView.tableView.dataSource = self
        self.historyView.tableView.delegate = self
        self.title = "HistoryHeader".localized(withComment: "")
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.historyView.searchController
        self.navigationItem.largeTitleDisplayMode = .always
        
        
    }
}

extension HistoryViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredHistory = historyCells.filter { historyCell in
                return historyCell.toLanguage?.languageName.lowercased().contains(searchText.lowercased()) ?? false ||
                    historyCell.fromLanguage?.languageName.lowercased().contains(searchText.lowercased()) ?? false ||
                    historyCell.text?.lowercased().contains(searchText.lowercased()) ?? false ||
                    historyCell.translatedText?.lowercased().contains(searchText.lowercased()) ?? false
            }
        } else {
            filteredHistory = historyCells
        }
        self.historyView.tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.historyView.searchController.isActive {
            return filteredHistory.count
        }
        return historyCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = self.historyView.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryViewCell
        let model: HistoryModel
        if self.historyView.searchController.isActive {
            model = self.filteredHistory[indexPath.row]
        } else {
            model = self.historyCells[indexPath.row]
        }
        myCell.selectionStyle = .none
        myCell.sourceLanguageLabel.text = model.fromLanguage?.languageName
        myCell.targetLanguageLabel.text = model.toLanguage?.languageName
        myCell.sourceTextLabel.text = model.text
        myCell.translatedTextLabel.text = model.translatedText
        guard let time = model.time else { return myCell}
        myCell.dateLabel.text = transformDateToString(date: time)
//        myCell.dateLabel.text = transformDateToString(date: model.time!)
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(HistoryDetailViewController(cell: self.historyCells[indexPath.row]), animated: true)
    }
    
    func transformDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd/MM/YY"
        }
        
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.historyView.searchController.isActive {
                historyCells = historyCells.filter { historyCell in
                    if historyCell != filteredHistory[indexPath.row] {
                        return true
                    }
                    return false
                }
                let coreDataController = CoreDataController()
                coreDataController.deleteFromHistory(historyModel: self.filteredHistory[indexPath.row])

                filteredHistory.remove(at: indexPath.row)
  
                tableView.deleteRows(at: [indexPath], with: .fade)

            } else {
                let coreDataController = CoreDataController()
                coreDataController.deleteFromHistory(historyModel: self.historyCells[indexPath.row])

                historyCells.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}


