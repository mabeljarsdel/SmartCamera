//
//  CollectionViewCellView.swift
//  Translate Camera
//
//  Created by Maksym on 09.01.2021.
//

import Foundation
import UIKit

class HistoryViewCell: UITableViewCell {
    
    let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byClipping

        return label
    }()
    
    let sourceTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byClipping
        label.numberOfLines = 2
        
        return label
    }()
    
    let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let translatedTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byClipping
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .systemGray2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    func initialize() {
//        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        
        contentView.addSubview(sourceLanguageLabel)
        contentView.addSubview(sourceTextLabel)
        contentView.addSubview(targetLanguageLabel)
        contentView.addSubview(translatedTextLabel)
        contentView.addSubview(dateLabel)
        
        
//        let margins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
//        contentView.frame = contentView.frame.inset(by: margins)

        
        sourceLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        sourceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceLanguageLabel.snp.bottom)
            make.width.equalTo(frame.width-20)
            make.leading.equalTo(contentView.snp.leading)
                .offset(10)
            make.trailing.equalTo(contentView.snp.trailing)
                .offset(-10)
        }
        
        
        targetLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceTextLabel.snp.bottom)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        translatedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(targetLanguageLabel.snp.bottom)
            make.width.equalTo(sourceTextLabel.snp.width)
            make.leading.equalTo(sourceTextLabel.snp.leading)
            make.trailing.equalTo(sourceTextLabel.snp.trailing)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(sourceTextLabel.snp.leading)
            make.trailing.equalTo(sourceLanguageLabel.snp.trailing)
            make.top.equalTo(sourceLanguageLabel.snp.top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        contentView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
}
