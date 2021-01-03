//
//  CameraMainView.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//

import Foundation
import UIKit

class CameraMainView: UIView {
    //MARK:- View Components
    let captureImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let borderPath = UIBezierPath(arcCenter: CGPoint(x: 40, y: 40), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineWidth = 2
        button.layer.addSublayer(borderLayer)
        
        return button
        
    }()
    
    let openGalleryButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "photo")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let openScanDocumentsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "doc.text.viewfinder")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let flashButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bolt.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "gear")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let historyButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "clock.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cameraView: CameraView = {
        let cameraView = CameraView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.setupAndStartCaptureSession()
        
        return cameraView
    }()
    
    let chooseLanguageView: ChooseLanguageSegmentView = {
        let chooseLanguageView = ChooseLanguageSegmentView()
        chooseLanguageView.translatesAutoresizingMaskIntoConstraints = false
        
        let chooseLanguageModel = ChooseLanguageModel.instance
        
        chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(chooseLanguageModel.getLanguage(languageType: .input).displayName, for: .normal)
        chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(chooseLanguageModel.getLanguage(languageType: .output).displayName, for: .normal)
        
        return chooseLanguageView
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = .black
        self.addSubview(captureImageButton)
        self.addSubview(openGalleryButton)
        self.addSubview(openScanDocumentsButton)
        self.addSubview(flashButton)
        self.addSubview(settingsButton)
        self.addSubview(historyButton)
        self.addSubview(cameraView)
        self.addSubview(chooseLanguageView)
        
        self.cameraView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo((UIScreen.main.bounds.width/3)*4)
            make.top.equalTo(self.snp.top)
            
        }
        captureImageButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(80)
            make.bottom.equalTo(self.snp.bottom).offset(-30)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        openGalleryButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.bottom.equalTo(self.snp.bottom).offset(-45)
            make.left.equalTo(self.snp.left).offset(25)
        }
        
        openScanDocumentsButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.bottom.equalTo(self.snp.bottom).offset(-45)
            make.right.equalTo(self.snp.right).offset(-25)
        }
        
        flashButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(captureImageButton.snp.top)
            make.left.equalTo(self.snp.left).offset(25)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(captureImageButton.snp.top)
            make.right.equalTo(self.snp.right).offset(-25)
        }
        
        historyButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(captureImageButton.snp.top)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        chooseLanguageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.centerX.equalTo(self.center.x)
            make.top.equalTo(self.snp.top).offset(60)
        }
    }
}
