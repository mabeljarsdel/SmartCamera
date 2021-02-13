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
        search.searchBar.placeholder = "Search".localized(withComment: "")
        return search
    }()
    
    var tableView: UITableView = {
        let layout = UITableView()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-40, height: 140)
        
//        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        layout.rowHeight = 140
        
        
        layout.register(HistoryViewCell.self, forCellReuseIdentifier: "Cell")
        layout.backgroundColor = .systemBackground
        return layout
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    func setupView() {
        self.setupCollectionView()
        self.searchController.hidesNavigationBarDuringPresentation = false
        

        
        self.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.top.equalTo(self.snp.top)
        }
    }
    
    func setupCollectionView() {

        addSubview(tableView)
        
    }
}
