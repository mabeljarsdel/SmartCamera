//
//  CollectionViewCellView.swift
//  Translate Camera
//
//  Created by Maksym on 09.01.2021.
//

import Foundation
import UIKit

class HistoryViewCell: UICollectionViewCell {
    
    let sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
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
        label.lineBreakMode = .byTruncatingTail
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
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        
        contentView.addSubview(sourceLanguageLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(targetLanguageLabel)
        contentView.addSubview(translatedTextLabel)
        contentView.addSubview(dateLabel)
        

        
        sourceLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceLanguageLabel.snp.bottom)
            make.width.equalTo(frame.width-20)
            make.leading.equalTo(contentView.snp.leading)
                .offset(10)
            make.trailing.equalTo(contentView.snp.trailing)
                .offset(-10)
        }
        
        
        targetLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        translatedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(targetLanguageLabel.snp.bottom)
            make.width.equalTo(textLabel.snp.width)
            make.leading.equalTo(textLabel.snp.leading)
            make.trailing.equalTo(textLabel.snp.trailing)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(textLabel.snp.leading)
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
