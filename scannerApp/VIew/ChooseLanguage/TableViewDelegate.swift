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
        return allLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let language = searchController.isActive ? filteredLanguages[indexPath.row] : allLanguages[indexPath.row]
        let countryName = translatorController.locale.localizedString(forLanguageCode: language.rawValue)
        cell.textLabel?.text = countryName
        
        let isLanguageDownloaded = downloadedLanguages.contains(countryName!)
        cell.accessoryView = self.buildAccessoryView(isDownloadedLanguage: isLanguageDownloaded, indexPath: indexPath)

        if self.translatorController.getLanguage(languageType: self.menuType) == language {
            cell.accessoryType = .checkmark
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
