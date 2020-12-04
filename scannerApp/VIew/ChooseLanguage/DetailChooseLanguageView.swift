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
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        self.setupContstraint()
        
    }
    
    func setupContstraint() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
            
        }
    }
    
}


extension DetailChooseLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = translatorController.locale.localizedString(forLanguageCode: allLanguages[indexPath.row].rawValue)
        
        if self.translatorController.getLanguage(languageType: self.menuType) == allLanguages[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        self.translatorController.setLanguage(languageType: self.menuType, newValue: allLanguages[indexPath.row])
        
        self.dismiss(animated: true)
    }
}


