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
    lazy var allLanguages: [LanguageModel] = {
        return TranslateLanguage.allLanguages()
            .map { lang in
                return LanguageModel(translateLanguage: lang)
            }.sorted {
                return $0.displayName < $1.displayName
            }
    }()

    let translatorController = ChooseLanguageModel.instance
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
        search.searchBar.placeholder = "Search".localized(withComment: "")
        return search
    }()

    //MARK: Lifecycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.menuType == .input && self.allLanguages[0] != LanguageModel(translateLanguage: TranslateLanguage(rawValue: Constants.autodetectionIdentifier)) {
            self.allLanguages.insert(LanguageModel(translateLanguage: TranslateLanguage(rawValue: Constants.autodetectionIdentifier)), at: 0)
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
        self.title = self.menuType == .input
            ? "TranslateFromHeader".localized(withComment: "")
            : "TranslateToHeader".localized(withComment: "")

        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
    }
    
    
    //MARK: Action-
    
    @objc func didTapDownloadDeleteLanguage(_ sender: UIButton?) {
        guard let button = sender else { return }
        let language = searchController.isActive ? filteredLanguages[button.tag] : allLanguages[button.tag]
        self.languageModelManager.handleDownloadDelete(language: language)
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
                print("Download successful")
                self.languageModelManager.downloading = self.languageModelManager.downloading.filter({ $0.languageCode != remoteModel.language.rawValue })
                if let firstInStack = self.languageModelManager.downloading.first {
                    self.languageModelManager.handleDownloadDelete(language: firstInStack)
                }
                
                self.allLanguages.filter({$0.languageCode == remoteModel.language.rawValue}).first?.changeModelStatus(newStatus: true)
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
            filteredLanguages = allLanguages.filter { language in
                return language.displayName.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredLanguages = allLanguages
        }
        tableView.reloadData()
    }
}


extension DetailChooseLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: Delegate function-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredLanguages.count
        }
        return allLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //build cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages[indexPath.row]
        
        cell.textLabel?.text = language.displayName
        
        
        //build accessoryView
        if self.translatorController.getLanguage(languageType: self.menuType).languageCode == language.languageCode {
            cell.accessoryType = .checkmark
            cell.accessoryView = nil
            
        } else if language.displayName == Constants.autodetectionIdentifier {
            cell.accessoryView = nil
            return cell
        } else {
            cell.accessoryView = self.buildAccessoryView(isDownloadedLanguage: language.getModelStatus(), indexPath: indexPath)
        }
        
        if self.languageModelManager.downloading.filter({ $0 == language }).first == language {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            cell.accessoryView = spinner
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages[indexPath.row]

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        self.translatorController.setLanguage(languageType: self.menuType, newValue: language)
        
        
        NotificationCenter.default.post(name: Notification.Name("LanugageChanged"), object: self.menuType)
        if searchController.isActive {
            self.dismiss(animated: false)
        }
        self.dismiss(animated: true)
    }
    
    //MARK: View-
    func buildAccessoryView(isDownloadedLanguage: Bool, indexPath: IndexPath) -> UIButton {
        let downloadDeleteLanguageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        downloadDeleteLanguageButton.addTarget(self, action: #selector(didTapDownloadDeleteLanguage(_:)),
                              for: .touchUpInside)
        downloadDeleteLanguageButton.tag = indexPath.row
        
        if isDownloadedLanguage {
            downloadDeleteLanguageButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
            downloadDeleteLanguageButton.tintColor = .red
        } else {
            downloadDeleteLanguageButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)

        }
        
        return downloadDeleteLanguageButton
    }
}
