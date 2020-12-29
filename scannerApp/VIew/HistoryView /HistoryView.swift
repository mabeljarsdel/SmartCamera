//
//  HistoryView.swift
//  Translate Camera
//
//  Created by Maksym on 26.12.2020.
//

import Foundation
import UIKit
import CoreData

class HistoryView: UIViewController {
    //MARK: View Elements
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var historyCell: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        let coreDataController = CoreDataController()
        self.historyCell = coreDataController.fetchFromHistory()
    }
    
    func setupView() {
        self.title = "History"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
        self.navigationItem.largeTitleDisplayMode = .always
        tableView.dataSource = self
        tableView.delegate = self
        self.view.backgroundColor = .white

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
        }
    }
}

extension HistoryView: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results ")
    }
}

extension HistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let historyCell = self.historyCell[indexPath.row]
        cell.textLabel?.text = historyCell.value(forKeyPath: HistoryModelConstant.fromLanguage) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(HistoryDetailView(cell: self.historyCell[indexPath.row]), animated: true)
    }
}

