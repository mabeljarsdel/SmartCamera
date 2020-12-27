//
//  ChooseLanguageDetailView.swift
//  scannerApp
//
//  Created by Maksym on 04.12.2020.
//

import Foundation
import UIKit
import MLKit

//TODO:- reload only row, not table


class DetailChooseLanguageViewController: UIViewController {
    
    var menuType: LanguageType!
    
    //MARK: Instances
    let translatorController = TranslatorController.translatorInstance
    lazy var allLanguages = LanguageStore.instance
    var languageModelManager = LanguageModelsManager.instance
    
    
    var filteredLanguages = [LanguageModel]()
    
    //MARK: View Elements
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()

    //MARK: Lifecycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.menuType == .input && self.allLanguages.languages[0] != LanguageModel(translateLanguage: TranslateLanguage(rawValue: "auto"), isDownloaded: false) {
            self.allLanguages.languages.insert(LanguageModel(translateLanguage: TranslateLanguage(rawValue: "auto"), isDownloaded: false), at: 0)
        }
        
        self.view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self

        self.setupNavigationBar()
        self.setupContstraint()
        self.setUpNotification()
    }
    
    func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteModelDownloadDeleteDidComplete(notificaiton:)), name: .mlkitModelDownloadDidSucceed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteModelDownloadDeleteDidComplete(notificaiton:)), name: .mlkitModelDownloadDidFail, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteModelDownloadDeleteDidComplete(notificaiton:)), name: Notification.Name("ModelDeleted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didStartDownload(notificaiton:)), name: Notification.Name("StartDownload"), object: nil)
    }
    
    //MARK: View-
    func setupContstraint() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
        }
    }
    
    func setupNavigationBar() {
        self.title = self.menuType == .input ? "Translate from" : "Translate to"

        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
    }
    
    
    //MARK: Action-
    
    @objc func didTapDownloadDeleteLanguage(_ sender: UIButton?) {
        guard let button = sender else { return }
        let language = searchController.isActive ? filteredLanguages[button.tag] : allLanguages.languages[button.tag]
        self.languageModelManager.handleDownloadDelete(language: language)
    }
    
    //MARK: Notification Center -
    @objc func remoteModelDownloadDeleteDidComplete(notificaiton: NSNotification) {
        
        
        guard let userInfo = notificaiton.userInfo else {
            
            guard let language = notificaiton.object as? LanguageModel else { return }
            
            self.allLanguages.languages.filter({$0 == language}).first?.changeModelStatus(newStatus: false)
            self.tableView.reloadData()
            print("Delete successful")
            return
        }
        
        guard let remoteModel = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel else { return }
        
        DispatchQueue.main.async { [self] in
            if notificaiton.name == .mlkitModelDownloadDidSucceed {
                print("Download successful")
                self.languageModelManager.downloading = self.languageModelManager.downloading.filter({ $0.languageCode != remoteModel.language.rawValue })
                if let firstInStack = self.languageModelManager.downloading.first {
                    self.languageModelManager.handleDownloadDelete(language: firstInStack)
                }
                
                self.allLanguages.languages.filter({$0.languageCode == remoteModel.language.rawValue}).first?.changeModelStatus(newStatus: true)
            } else {
                print("Download failed")
            }
            tableView.reloadData()
        }
    }
    
    @objc func didStartDownload(notificaiton: NSNotification) {
        print("download started")
        tableView.reloadData()
    }
}

extension DetailChooseLanguageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredLanguages = allLanguages.languages.filter { language in
                return language.displayName.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredLanguages = allLanguages.languages
        }
        tableView.reloadData()
    }
}
