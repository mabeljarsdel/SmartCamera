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
    
    lazy var allLanguages: [LanguageModel] = {
        return TranslateLanguage.allLanguages()
            .map { lang in
                return LanguageModel(translateLanguage: lang, isDownloaded: languageModelManager.isLanguageDownloaded(lang))
            }.sorted {
                return $0.displayName < $1.displayName
            }
    }()
    
    var filteredLanguages = [LanguageModel]()
    var languageModelManager = LanguageModelsManager.instance
    
    //MARK: View Elements
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()
    
    
    //MARK: Lifecycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.menuType == .input {
            self.allLanguages.insert(LanguageModel(translateLanguage: TranslateLanguage(rawValue: "auto"), isDownloaded: false), at: 0)
        }
        
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        self.setupContstraint()
        searchController.searchResultsUpdater = self
        
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

        let standaloneItem = UINavigationItem()
        standaloneItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))

        standaloneItem.titleView = UILabel()
        standaloneItem.searchController = searchController
        let navigationBar = UINavigationBar()
        navigationBar.delegate = self
        navigationBar.backgroundColor = .white
        navigationBar.items = [standaloneItem]

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
 
        
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
    
    
    //MARK: Action-
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapDownloadDeleteLanguage(_ sender: UIButton?) {
        guard let button = sender else { return }
        print(button.tag)
        let language = searchController.isActive ? filteredLanguages[button.tag] : allLanguages[button.tag]
        self.languageModelManager.handleDownloadDelete(language: language, tag: button.tag)
    }
    
    
    @objc func CancelClicked(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Notification Center -
    @objc func remoteModelDownloadDeleteDidComplete(notificaiton: NSNotification) {
        
        
        guard let userInfo = notificaiton.userInfo else {
            guard let language = notificaiton.object as? LanguageModel else { return }
            self.allLanguages.filter({$0 == language}).first?.changeModelStatus(newStatus: false)
            self.tableView.reloadData()
            print("Delete successful")
            return
        }
        
        guard let remoteModel = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel else { return }
        
        DispatchQueue.main.async { [self] in
            if notificaiton.name == .mlkitModelDownloadDidSucceed {
                print("Success")
                self.languageModelManager.downloading = nil
                self.allLanguages.filter({$0.languageCode == remoteModel.language.rawValue}).first?.changeModelStatus(newStatus: true)
            } else {
                print("Download failed")
            }
            tableView.reloadData()
        }
    }
    @objc func didStartDownload(notificaiton: NSNotification) {
        tableView.reloadData()
    }
}



extension DetailChooseLanguageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredLanguages = allLanguages.filter { language in
                return language.displayName.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredLanguages = allLanguages
        }
        tableView.reloadData()
    }
}

extension DetailChooseLanguageViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

