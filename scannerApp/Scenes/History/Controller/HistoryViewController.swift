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
    
    var historyCell: [HistoryModel] = []
    
    
    override func loadView() {
        super.loadView()
        self.historyView = HistoryView()
        self.view = historyView

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let coreDataController = CoreDataController()
        self.historyCell = coreDataController.fetchFromHistory()
        self.historyCell.sort(by: { $0.time! > $1.time! })
        
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
        print("update search results ")
    }
}

extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = self.historyView.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HistoryViewCell
        let model = self.historyCell[indexPath.row]
        myCell.sourceLanguageLabel.text = model.fromLanguage?.languageName
        myCell.targetLanguageLabel.text = model.toLanguage?.languageName
        myCell.textLabel.text = model.text
        myCell.translatedTextLabel.text = model.translatedText
        myCell.dateLabel.text = transformDateToString(date: model.time!)
        return myCell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(HistoryDetailViewController(cell: self.historyCell[indexPath.row]), animated: true)
    }
    
    func transformDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        // Set Date Format
        
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"   // 20, Oct 29, 14:18:31
        }
        else {
            dateFormatter.dateFormat = "dd/MM/YY"
        }
        
        return dateFormatter.string(from: date)
    }
}

//extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return historyCell.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
//        let historyCell = self.historyCell[indexPath.row]
//        let dateFormatter = DateFormatter()
//        let calendar = Calendar.current
//        // Set Date Format
//
//        cell.accessoryType = .disclosureIndicator
//
//        if calendar.isDateInToday(historyCell.time!) {
//            dateFormatter.dateFormat = "HH:mm"   // 20, Oct 29, 14:18:31
//        } else {
//            dateFormatter.dateFormat = "YY:MM:dd"
//        }
//
//
//        cell.textLabel?.text = historyCell.fromLanguage! + " -> " + historyCell.toLanguage!
//        cell.detailTextLabel?.text = dateFormatter.string(from: historyCell.time!)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(HistoryDetailViewController(cell: self.historyCell[indexPath.row]), animated: true)
//    }
//}


extension String {
    var languageName: String {
        Locale.current.localizedString(forLanguageCode: self) ?? "Wrong language code"
    }
}
