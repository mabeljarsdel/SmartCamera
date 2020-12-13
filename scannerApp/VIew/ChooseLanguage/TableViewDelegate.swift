//
//  TableViewDelegate.swift
//  Translate Camera
//
//  Created by Maksym on 13.12.2020.
//

import Foundation
import UIKit

extension DetailChooseLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredLanguages.count
        }
        return allLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages[indexPath.row]
        
        let countryName = translatorController.locale.localizedString(forLanguageCode: language.rawValue)
        
        
        cell.textLabel?.text = countryName
        
        if self.downloadedLanguages.contains(countryName!) {
            let downloadLanguage = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            //MARK: ADD delete action
            downloadLanguage.addTarget(self, action: #selector(didTapDownloadDeleteLanguage(_:)),
                                  for: .touchUpInside)
            downloadLanguage.tag = indexPath.row
            downloadLanguage.setImage(UIImage(systemName: "x.circle"), for: .normal)
            downloadLanguage.tintColor = .red
            downloadLanguage.tag = indexPath.row
            cell.accessoryView = downloadLanguage
        } else {
            let deleteLanguage = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            //MARK: ADD download action
            deleteLanguage.tag = indexPath.row
            deleteLanguage.addTarget(self, action: #selector(didTapDownloadDeleteLanguage(_:)), for: .touchUpInside)
            deleteLanguage.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
            
            deleteLanguage.tag = indexPath.row
            cell.accessoryView = deleteLanguage
        }
        
        
        if self.translatorController.getLanguage(languageType: self.menuType) == language {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages[indexPath.row]

        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        self.translatorController.setLanguage(languageType: self.menuType, newValue: language)
        
        if searchController.isActive {
            self.dismiss(animated: true)
        }
        self.dismiss(animated: true)
    }
}
