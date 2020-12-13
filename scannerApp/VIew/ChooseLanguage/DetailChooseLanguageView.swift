//
//  ChooseLanguageDetailView.swift
//  scannerApp
//
//  Created by Maksym on 04.12.2020.
//

import Foundation
import UIKit
import MLKit


class DetailChooseLanguageView: UIView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        
    }
}

class DetailChooseLanguageViewController: UIViewController {
    
    var menuType: LanguageType!
    
    //MARK: Instances
    let translatorController = TranslatorController.translatorInstance
    
    lazy var allLanguages = TranslateLanguage.allLanguages().sorted {
        return translatorController.locale.localizedString(forLanguageCode: $0.rawValue)!
            < translatorController.locale.localizedString(forLanguageCode: $1.rawValue)!
    }
    
    var filteredLanguages = [TranslateLanguage]()
    var languageModelManager = LanguageModelsManager()

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
    
    var downloadedLanguages = [String]()
    
    //MARK: Lifecycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        self.setupContstraint()
        
        
        self.downloadedLanguages = languageModelManager.listDownloadedModels().components(separatedBy: ", ")
        languageModelManager.downloadLanguage(language: TranslateLanguage(rawValue: "fr"))

        searchController.searchResultsUpdater = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageModelManager.remoteModelDownloadDidComplete(notificaiton:)), name: .mlkitModelDownloadDidSucceed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageModelManager.remoteModelDownloadDidComplete(notificaiton:)), name: .mlkitModelDownloadDidFail, object: nil)
        
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

        if #available(iOS 11, *) {
          navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
          navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
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
        self.languageModelManager.handleDownloadDelete(language: language)
    }
    
    
    @objc func CancelClicked(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Notification Center -
    @objc func remoteModelDownloadDidComplete(notificaiton: NSNotification) {
        let userInfo = notificaiton.userInfo!
        guard let remoteModel = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel
        else {
            return
        }
        let languageName = Locale.current.localizedString(
            forLanguageCode: remoteModel.language.rawValue)!
        DispatchQueue.main.async {
            print(languageName)
            if notificaiton.name == .mlkitModelDownloadDidSucceed {
                print("Success")
            } else {
                print("Download failed")
            }
        }
    }
}



extension DetailChooseLanguageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredLanguages = allLanguages.filter { language in
                guard let languageName = translatorController.locale.localizedString(forLanguageCode: language.rawValue) else { return false }
                
                return languageName.lowercased().contains(searchText.lowercased())
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

