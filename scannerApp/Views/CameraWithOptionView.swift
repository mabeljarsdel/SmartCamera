//
//  CameraWithOptionView.swift
//  Translate Camera
//
//  Created by Maksym on 03.01.2021.
//

import Foundation
import UIKit
import AVFoundation


class CameraWithOptionView: UIView {
    //MARK:- View Components
    let captureImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let borderPath = UIBezierPath(arcCenter: CGPoint(x: 35, y: 35), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
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

//
//    let flashButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "bolt.circle.fill")
//        button.setImage(image, for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
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
    
    let modePicker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))

        return view
    }()
    
    let navigationBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    

    
    lazy var cropBox: ResizableView = {
        
        let x = cameraView.center.x
        let y = cameraView.center.y
        let sizeWidth = cameraView.frame.width/2
        let sizeHeight = cameraView.frame.height/2
        let resizableView = ResizableView(frame: CGRect(x: x-(sizeWidth/2), y: y-(sizeHeight/2),
                                                        width: sizeWidth, height: sizeHeight))
        
        resizableView.defaultSizeWidth = sizeWidth
        resizableView.defaultSizeHeight = sizeHeight
        resizableView.defaultCenter = CGPoint(x: x, y: y)
        resizableView.translatesAutoresizingMaskIntoConstraints = false
        resizableView.isUserInteractionEnabled = true
        return resizableView
    }()
    
    var modes: [CameraModes] = CameraModes.allCases

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
        
        
    }
    
    func setupView() {
        self.backgroundColor = .black
        self.addSubview(navigationBar)
        self.addSubview(cameraView)
        navigationBar.addSubview(captureImageButton)
        navigationBar.addSubview(openGalleryButton)
        navigationBar.addSubview(openScanDocumentsButton)
//        navigationBar.addSubview(flashButton)
        navigationBar.addSubview(settingsButton)
        navigationBar.addSubview(historyButton)
        self.addSubview(chooseLanguageView)
        navigationBar.addSubview(modePicker)
        
        
        cameraView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.height.equalTo((UIScreen.main.bounds.width/3)*4)
            make.top.equalTo(self.snp.top)
            
        }
        
        
        
        navigationBar.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(UIScreen.main.bounds.height - cameraView.frame.height)
        }
        
        captureImageButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(70)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
//        flashButton.snp.makeConstraints { make in
//            make.width.height.equalTo(60)
//            make.bottom.equalTo(captureImageButton.snp.top).offset(10)
//            make.left.equalTo(self.snp.left).offset(25)
//        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.equalTo(captureImageButton.snp.top).offset(10)
            make.right.equalTo(self.snp.right).offset(-25)
        }
        
        historyButton.snp.makeConstraints { make in
            make.width.height.equalTo(settingsButton.snp.width)
            make.bottom.equalTo(settingsButton.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        openGalleryButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(settingsButton.snp.width)
            make.centerY.equalTo(captureImageButton.snp.centerY)
            make.left.equalTo(self.snp.left).offset(25)
        }
        
        openScanDocumentsButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(settingsButton.snp.width)
            make.centerY.equalTo(captureImageButton.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-25)
        }
        
        chooseLanguageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.centerX.equalTo(self.center.x)
            make.top.equalTo(self.snp.top).offset(60)
        }
        
        modePicker.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(historyButton.snp.top).offset(-5)
            make.height.equalTo(frame.width+300)
            make.width.equalTo(45)
        }
    }

}

