//
//  ChooseLanguageSegmentView.swift
//  scannerApp
//
//  Created by Maksym on 04.12.2020.
//

import Foundation
import UIKit


class ChooseLanguageSegmentView: UIView {
    
    var labelOfLanguageFromTranslate: UILabel = {
        let label = UILabel()
        label.text = "English"
        label.textAlignment = .center
        //        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelOfTranslateIntoLanguage: UILabel = {
        let label = UILabel()
        label.text = "Spanish"
        label.textAlignment = .center
        //        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var swapButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.2.circlepath")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        alpha = 0.5
        layer.cornerRadius = 20
        
        addSubview(self.labelOfLanguageFromTranslate)
        
        labelOfLanguageFromTranslate.snp.makeConstraints { make in
            make.width.equalTo(((bounds.width)/2)-30)
            make.height.equalTo(bounds.height-10)
            make.left.equalTo(snp.left).offset(10)
            make.centerY.equalTo(snp.centerY)
        }
        
        
        addSubview(self.labelOfTranslateIntoLanguage)
        
        labelOfTranslateIntoLanguage.snp.makeConstraints { make in
            make.width.equalTo(((bounds.width)/2)-30)
            make.height.equalTo(bounds.height-10)
            make.right.equalTo(snp.right).offset(-10)
            make.centerY.equalTo(snp.centerY)
        }
        
        addSubview(self.swapButton)
        
        swapButton.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            
        }
    }
}
