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
        self.setupView()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let coreDataController = CoreDataController()
        self.historyCell = coreDataController.fetchFromHistory()
        self.historyCell.sort(by: { $0.time! > $1.time! })
    }
    
    func setupView() {
        self.historyView.searchController.delegate = self
        self.historyView.searchController.searchResultsUpdater = self
        self.historyView.tableView.dataSource = self
        self.historyView.tableView.delegate = self
        
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let historyCell = self.historyCell[indexPath.row]
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        // Set Date Format
        
        cell.accessoryType = .disclosureIndicator
        
        if calendar.isDateInToday(historyCell.time!) {
            dateFormatter.dateFormat = "HH:mm"   // 20, Oct 29, 14:18:31
        } else {
            dateFormatter.dateFormat = "YY:MM:dd"
        }
        
        
        cell.textLabel?.text = historyCell.fromLanguage! + " -> " + historyCell.toLanguage!
        cell.detailTextLabel?.text = dateFormatter.string(from: historyCell.time!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(HistoryDetailViewController(cell: self.historyCell[indexPath.row]), animated: true)
    }
}

