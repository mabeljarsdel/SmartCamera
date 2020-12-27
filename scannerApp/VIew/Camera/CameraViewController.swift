//
//  CameraView.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import UIKit
import AVFoundation
import SnapKit
import VisionKit

class CameraViewController: UIViewController {
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
        
        chooseLanguageView.buttonOfLanguageFromTranslate.addTarget(self, action: #selector(openDetailView(_ :)), for: .touchUpInside)
        chooseLanguageView.buttonOfTranslateIntoLanguage.addTarget(self, action: #selector(openDetailView(_:)), for: .touchUpInside)
        chooseLanguageView.swapButton.addTarget(self, action: #selector(swapLanguageButton(_:)), for: .touchUpInside)
        return chooseLanguageView
    }()
    
    var takePicture: Bool = false
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(cameraView)
        
        self.configCameraViewConstraints()
        self.setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged(notification:)), name: Notification.Name("LanugageChanged"), object: nil)
        
        view.addSubview(self.chooseLanguageView)
        
        self.chooseLanguageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(view.snp.top).offset(60)
        }
        
        
        checkPermissions()
        self.setupOutput()

    }
    
    @objc func languageChanged(notification: NSNotification) {
        guard let languageType = notification.object as? LanguageType else { return }
        let translatorController = TranslatorController.translatorInstance
        if languageType == .input {
            self.chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(translatorController.getLanguage(languageType: .input).displayName, for: .normal)
        } else {
            self.chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(translatorController.getLanguage(languageType: .output).displayName, for: .normal)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let translatorController = TranslatorController.translatorInstance
        
        chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(translatorController.getLanguage(languageType: .input).displayName, for: .normal)
        chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(translatorController.getLanguage(languageType: .output).displayName, for: .normal)
        
    }
    
    //MARK:- Actions
    
    @objc func openDetailView(_ sender: UIButton) {
        let detailView = DetailChooseLanguageViewController()
        if sender.tag == 0 {
            detailView.menuType = .input
        } else {
            detailView.menuType = .output
        }
        detailView.modalPresentationStyle = .formSheet
        self.present(UINavigationController(rootViewController: detailView), animated: true)
    }
    
    @objc func swapLanguageButton(_ sender: UIButton?) {
        
        let translatorController = TranslatorController.translatorInstance
        
        if translatorController.getLanguage(languageType: .input).displayName == Constant.autodetectionIdentifier {
            return
        }
        
        let tempOutputLanguage = translatorController.getLanguage(languageType: .output)
        
        translatorController.setLanguage(languageType: .output, newValue: translatorController.getLanguage(languageType: .input))
        translatorController.setLanguage(languageType: .input, newValue: tempOutputLanguage)
        
        chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(translatorController.getLanguage(languageType: .input).displayName, for: .normal)
        chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(translatorController.getLanguage(languageType: .output).displayName, for: .normal)
        
    }
    
    @objc func captureImage(_ sender: UIButton?) {
        self.takePicture = true
    }
    
    @objc func openGallery(_ sender: UIButton?) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func openScanDocuments(_ sender: UIButton?) {
        guard VNDocumentCameraViewController.isSupported else { return }

        let controller = VNDocumentCameraViewController()
        
        controller.delegate = self

        present(controller, animated: true)
    }
    
    @objc func turnOnFlash(_ sender: UIButton?) {
        do {
            try self.cameraView.device.lockForConfiguration()
            self.cameraView.device.torchMode = self.cameraView.device.torchMode == .on ? .off : .on
            if self.cameraView.device.torchMode == .on {
                try self.cameraView.device.setTorchModeOn(level: 1)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func openSettings(_ sender: UIButton?) {
        let settingsView = SettingsView()
        settingsView.modalPresentationStyle = .formSheet
        self.present(settingsView, animated: true)
    }
    
    @objc func openHistory(_ sender: UIButton?) {
            let settingsView = HistoryView()
            settingsView.modalPresentationStyle = .formSheet
        
            self.present(UINavigationController(rootViewController: settingsView), animated: true)
    }
}


extension CameraViewController {
    //MARK:- View Setup
    func setupView() {
        view.backgroundColor = .black
        view.addSubview(captureImageButton)
        view.addSubview(openGalleryButton)
        view.addSubview(openScanDocumentsButton)
        view.addSubview(flashButton)
        view.addSubview(settingsButton)
        view.addSubview(historyButton)
        
        captureImageButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(80)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        openGalleryButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view.snp.bottom).offset(-45)
            make.left.equalTo(view.snp.left).offset(25)
        }
        
        openScanDocumentsButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view.snp.bottom).offset(-45)
            make.right.equalTo(view.snp.right).offset(-25)
        }
        
        flashButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(captureImageButton.snp.top)
            make.left.equalTo(view.snp.left).offset(25)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(captureImageButton.snp.top)
            make.right.equalTo(view.snp.right).offset(-25)
        }
        
        historyButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(captureImageButton.snp.top)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        flashButton.addTarget(self, action: #selector(turnOnFlash(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openSettings(_:)), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(openHistory(_:)), for: .touchUpInside)
        captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        openGalleryButton.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        openScanDocumentsButton.addTarget(self, action: #selector(openScanDocuments(_:)), for: .touchUpInside)

    }
    
    func setupOutput() {
        cameraView.output = AVCaptureVideoDataOutput()
        
        let videoQueue = DispatchQueue(label: self.cameraView.videoQueueLabel, qos: .userInteractive)
        cameraView.output.setSampleBufferDelegate(self, queue: videoQueue)
        
        if cameraView.session.canAddOutput(cameraView.output) {
            cameraView.session.addOutput(cameraView.output)
        } else {
            fatalError("could not add video output")
        }
        
        
        cameraView.output.connections.first?.videoOrientation = .portrait
        
    }
    
    func configCameraViewConstraints() {
        self.cameraView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo((UIScreen.main.bounds.width/3)*4)
            make.top.equalTo(view.snp.top)
            
        }
    }
    
    //MARK:- Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
        case .authorized:
            return
        case .denied:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                                            { (authorized) in
                                                if(!authorized){
                                                    abort()
                                                }
                                            })
        case .restricted:
            abort()
        @unknown default:
            fatalError()
        }
    }
}


