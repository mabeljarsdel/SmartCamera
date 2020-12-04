//
//  ChooseLanguageSegmentView.swift
//  scannerApp
//
//  Created by Maksym on 04.12.2020.
//

import Foundation
import UIKit

class ChooseLanguageSegmentViewController: UIViewController {
    
    var chooseLanguageView: ChooseLanguageSegmentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chooseLanguageView = ChooseLanguageSegmentView()
        chooseLanguageView.translatesAutoresizingMaskIntoConstraints = false
        
        chooseLanguageView.buttonOfLanguageFromTranslate.addTarget(self, action: #selector(self.openDetailView(_:)), for: .touchDown)
        
        print(self.parent)

        self.chooseLanguageView = chooseLanguageView
        view.addSubview(self.chooseLanguageView)
        self.chooseLanguageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.screenWidth - 60)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(view.snp.top).offset(60)
        }
        
    }
    
    @objc func openDetailView(_ sender: UIButton?) {
        let detailView = DetailChooseLanguageViewController()
        detailView.modalPresentationStyle = .formSheet
        self.present(detailView, animated: true)
    }
}

class ChooseLanguageSegmentView: UIView {
    
    var buttonOfLanguageFromTranslate: UIButton = {
        let button = UIButton()
        button.setTitle("English", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.green, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var buttonOfTranslateIntoLanguage: UIButton = {
        let button = UIButton()
        button.setTitle("Spanish", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
//        alpha = 0.7
        layer.cornerRadius = 20
        
        self.setConstraint()

    }
    
    func setConstraint() {
        addSubview(self.buttonOfLanguageFromTranslate)
        buttonOfLanguageFromTranslate.snp.makeConstraints { make in
            make.width.equalTo(((bounds.width)/2)-30)
            make.height.equalTo(bounds.height)
            make.left.equalTo(snp.left).offset(10)
            make.centerY.equalTo(snp.centerY)
        }
        
        
        addSubview(self.buttonOfTranslateIntoLanguage)
        buttonOfTranslateIntoLanguage.snp.makeConstraints { make in
            make.width.equalTo(((bounds.width)/2)-30)
            make.height.equalTo(bounds.height)
            make.right.equalTo(snp.right).offset(-10)
            make.centerY.equalTo(snp.centerY)
        }
        
        addSubview(self.swapButton)
        swapButton.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            
        }
    }
}

