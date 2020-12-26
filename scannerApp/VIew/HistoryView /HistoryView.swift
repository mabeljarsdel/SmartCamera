//
//  HistoryView.swift
//  Translate Camera
//
//  Created by Maksym on 26.12.2020.
//

import Foundation
import UIKit


class HistoryView: UIViewController {
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        self.navigationItem.searchController = self.searchController
        self.navigationItem.largeTitleDisplayMode = .always
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.view.backgroundColor = .white
    }
}

extension HistoryView: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results ")
    }
}
