//
//  HistoryView.swift
//  Translate Camera
//
//  Created by Maksym on 09.01.2021.
//

import Foundation
import UIKit


class HistoryView: UIView {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    func setupView() {
        self.searchController.hidesNavigationBarDuringPresentation = false

        self.backgroundColor = .white

        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.top.equalTo(self.snp.top)
        }
    }
}
