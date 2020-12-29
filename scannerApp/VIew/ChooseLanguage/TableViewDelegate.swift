//
//  TableViewDelegate.swift
//  Translate Camera
//
//  Created by Maksym on 13.12.2020.
//

import Foundation
import UIKit

extension DetailChooseLanguageViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: Delegate function-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredLanguages.count
        }
        return allLanguages.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //build cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages.languages[indexPath.row]
        
        cell.textLabel?.text = language.displayName
        
        
        //build accessoryView
        if self.translatorController.getLanguage(languageType: self.menuType).languageCode == language.languageCode {
            cell.accessoryType = .checkmark
            cell.accessoryView = nil
            
        } else if language.displayName == Constant.autodetectionIdentifier {
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

        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages.languages[indexPath.row]

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
