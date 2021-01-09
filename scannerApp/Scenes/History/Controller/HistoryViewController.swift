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
//        self.historyView.tableView.dataSource = self
//        self.historyView.tableView.delegate = self
        self.historyView.collectionView.dataSource = self
        self.historyView.collectionView.delegate = self
        self.title = "History"
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
        self.historyView.collectionView.reloadData()
    }
}

extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.historyView.searchController.isActive {
            return filteredHistory.count
        }
        return historyCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = self.historyView.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HistoryViewCell
        let model: HistoryModel
        if self.historyView.searchController.isActive {
            model = self.filteredHistory[indexPath.row]
        } else {
            model = self.historyCells[indexPath.row]
        }
        myCell.sourceLanguageLabel.text = model.fromLanguage?.languageName
        myCell.targetLanguageLabel.text = model.toLanguage?.languageName
        myCell.textLabel.text = model.text
        myCell.translatedTextLabel.text = model.translatedText
        myCell.dateLabel.text = transformDateToString(date: model.time!)
        return myCell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(HistoryDetailViewController(cell: self.historyCells[indexPath.row]), animated: true)
    }
    
    func transformDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        }
        else {
            dateFormatter.dateFormat = "dd/MM/YY"
        }
        
        return dateFormatter.string(from: date)
    }
}



extension String {
    var languageName: String {
        Locale.current.localizedString(forLanguageCode: self) ?? "Wrong language code"
    }
}
