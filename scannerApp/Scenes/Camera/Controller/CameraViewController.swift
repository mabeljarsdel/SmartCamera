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
import QCropper


class CameraViewController: UIViewController {
    
    var takePicture: Bool = false
    var cameraMainView = CameraMainView()
    var currentMode: CameraModes = .translation
    
    
    var lastFrame: CMSampleBuffer?
    

    lazy var cropBox: ResizableView = {
        
        let x = cameraMainView.cameraView.center.x
        let y = cameraMainView.cameraView.center.y
        let sizeWidth = cameraMainView.cameraView.frame.width/2
        let sizeHeight = cameraMainView.cameraView.frame.height/2
        let resizableView = ResizableView(frame: CGRect(x: x-(sizeWidth/2), y: y-(sizeHeight/2),
                                                        width: sizeWidth, height: sizeHeight))
        
        resizableView.defaultSizeWidth = sizeWidth
        resizableView.defaultSizeHeight = sizeHeight
        resizableView.defaultCenter = CGPoint(x: x, y: y)
        resizableView.translatesAutoresizingMaskIntoConstraints = false
        resizableView.isUserInteractionEnabled = true
        return resizableView
    }()


    //MARK:- Lifecycle
    override func loadView() {
        super.loadView()
        cameraMainView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cameraMainView)
        
        cameraMainView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        
        
        cameraMainView.modePicker.dataSource = self
        cameraMainView.modePicker.delegate = self
        cameraMainView.modePicker.selectRow(2, inComponent: 0, animated: false)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAction()
        setupObservers()
        checkPermissions()
        setupOutput()
        
        let reachability = Reachability.instance
        print(reachability.connectionStatus)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cameraMainView.cameraView.addSubview(cropBox)

    }

    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged(notification:)), name: Notification.Name("LanugageChanged"), object: nil)
    }
    
    func setupViewAction() {
        
//        cameraMainView.flashButton.addTarget(self, action: #selector(toggleFlash(_:)), for: .touchUpInside)
        cameraMainView.settingsButton.addTarget(self, action: #selector(openSettings(_:)), for: .touchUpInside)
        cameraMainView.historyButton.addTarget(self, action: #selector(openHistory(_:)), for: .touchUpInside)
        cameraMainView.captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        cameraMainView.openGalleryButton.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        cameraMainView.openScanDocumentsButton.addTarget(self, action: #selector(openScanDocuments(_:)), for: .touchUpInside)
        
        cameraMainView.chooseLanguageView.buttonOfLanguageFromTranslate.addTarget(self, action: #selector(openChooseLanguageDetailView(_ :)), for: .touchUpInside)
        cameraMainView.chooseLanguageView.buttonOfTranslateIntoLanguage.addTarget(self, action: #selector(openChooseLanguageDetailView(_:)), for: .touchUpInside)
        cameraMainView.chooseLanguageView.swapButton.addTarget(self, action: #selector(swapLanguageButton(_:)), for: .touchUpInside)

    }
    
    @objc func languageChanged(notification: NSNotification) {
        guard let languageType = notification.object as? LanguageType else { return }
        let chooseLanguageModel = ChooseLanguageModel.instance
        if languageType == .input {
            cameraMainView.chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(chooseLanguageModel.getLanguage(languageType: .input).displayName, for: .normal)
        } else {
            cameraMainView.chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(chooseLanguageModel.getLanguage(languageType: .output).displayName, for: .normal)
        }
    }
    

    
    //MARK:- Actions
    @objc func swapLanguageButton(_ sender: UIButton?) {
        
        let chooseLanguageModel = ChooseLanguageModel.instance
        
        if chooseLanguageModel.getLanguage(languageType: .input).displayName == Constant.autodetectionIdentifier {
            return
        }
        
        let tempOutputLanguage = chooseLanguageModel.getLanguage(languageType: .output)
        
        chooseLanguageModel.setLanguage(languageType: .output, newValue: chooseLanguageModel.getLanguage(languageType: .input))
        chooseLanguageModel.setLanguage(languageType: .input, newValue: tempOutputLanguage)
        
        cameraMainView.chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(chooseLanguageModel.getLanguage(languageType: .input).displayName, for: .normal)
        cameraMainView.chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(chooseLanguageModel.getLanguage(languageType: .output).displayName, for: .normal)
        
    }
    
    @objc func captureImage(_ sender: UIButton?) {
        self.takePicture = true
    }
    
    
    @objc func toggleFlash(_ sender: UIButton?) {
        do {
            try self.cameraMainView.cameraView.device.lockForConfiguration()
            self.cameraMainView.cameraView.device.torchMode = self.cameraMainView.cameraView.device.torchMode == .on ? .off : .on
            if self.cameraMainView.cameraView.device.torchMode == .on {
                try self.cameraMainView.cameraView.device.setTorchModeOn(level: 1)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Navigation action
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
    
    
    @objc func openSettings(_ sender: UIButton?) {
        let settingsView = SettingsView()
        settingsView.modalPresentationStyle = .formSheet
        self.present(settingsView, animated: true)
    }
    
    @objc func openHistory(_ sender: UIButton?) {
        let settingsView = HistoryViewController()
        settingsView.modalPresentationStyle = .formSheet
        
        self.present(UINavigationController(rootViewController: settingsView), animated: true)
    }
    
    
    @objc func openChooseLanguageDetailView(_ sender: UIButton) {
        let detailView = DetailChooseLanguageViewController()
        if sender.tag == 0 {
            detailView.menuType = .input
        } else {
            detailView.menuType = .output
        }
        detailView.modalPresentationStyle = .formSheet
        self.present(UINavigationController(rootViewController: detailView), animated: true)
    }
}


extension CameraViewController {
    func setupOutput() {
        cameraMainView.cameraView.output = AVCaptureVideoDataOutput()
        
        let videoQueue = DispatchQueue(label: self.cameraMainView.cameraView.videoQueueLabel, qos: .userInteractive)
        cameraMainView.cameraView.output.setSampleBufferDelegate(self, queue: videoQueue)
        
        if cameraMainView.cameraView.session.canAddOutput(cameraMainView.cameraView.output) {
            cameraMainView.cameraView.session.addOutput(cameraMainView.cameraView.output)
        } else {
            fatalError("could not add video output")
        }
        
        
        cameraMainView.cameraView.output.connections.first?.videoOrientation = .portrait
        
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


extension CameraViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cameraMainView.modes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        modeLabel.textColor = .yellow
        modeLabel.text = self.cameraMainView.modes[row].description
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return modeView
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentMode = self.cameraMainView.modes[row]

    }
}
