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
import MLKit
import UIDrawer

class CameraViewController: UIViewController {
    
    var takePicture: Bool = false
    lazy var cameraWithOptionView : CameraWithOptionView = {
        let cameraWithOptionView = CameraWithOptionView()
        cameraWithOptionView.translatesAutoresizingMaskIntoConstraints = false

        return cameraWithOptionView
    }()
    
    var currentMode: CameraModes = .translation
    var lastFrame: CMSampleBuffer?
    

    //MARK:- Lifecycle
    override func loadView() {
        super.loadView()
        self.view.addSubview(cameraWithOptionView)
        
        cameraWithOptionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        
        cameraWithOptionView.modePicker.dataSource = self
        cameraWithOptionView.modePicker.delegate = self
        cameraWithOptionView.modePicker.selectRow(2, inComponent: 0, animated: false)


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
        self.cameraWithOptionView.cameraView.addSubview(self.cameraWithOptionView.cropBox)
        
    }

    
    func displaySubscribeBanner() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.modalPresentationStyle = .formSheet
        self.present(subscriptionViewController, animated: true)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged(notification:)), name: Notification.Name("LanugageChanged"), object: nil)
    }
    
    func setupViewAction() {
        
//        cameraWithOptionView.flashButton.addTarget(self, action: #selector(toggleFlash(_:)), for: .touchUpInside)
        cameraWithOptionView.settingsButton.addTarget(self, action: #selector(openSettings(_:)), for: .touchUpInside)
        cameraWithOptionView.historyButton.addTarget(self, action: #selector(openHistory(_:)), for: .touchUpInside)
        cameraWithOptionView.captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        cameraWithOptionView.openGalleryButton.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        cameraWithOptionView.openScanDocumentsButton.addTarget(self, action: #selector(openScanDocuments(_:)), for: .touchUpInside)
        
        cameraWithOptionView.chooseLanguageView.buttonOfLanguageFromTranslate.addTarget(self, action: #selector(openChooseLanguageDetailView(_ :)), for: .touchUpInside)
        cameraWithOptionView.chooseLanguageView.buttonOfTranslateIntoLanguage.addTarget(self, action: #selector(openChooseLanguageDetailView(_:)), for: .touchUpInside)
        cameraWithOptionView.chooseLanguageView.swapButton.addTarget(self, action: #selector(swapLanguageButton(_:)), for: .touchUpInside)

    }
    
    @objc func languageChanged(notification: NSNotification) {
        guard let languageType = notification.object as? LanguageType else { return }
        let chooseLanguageModel = ChooseLanguageModel.instance
        if languageType == .input {
            cameraWithOptionView.chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(chooseLanguageModel.getLanguage(languageType: .input).displayName, for: .normal)
        } else {
            cameraWithOptionView.chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(chooseLanguageModel.getLanguage(languageType: .output).displayName, for: .normal)
        }
    }
    
    
    
    //MARK:- Actions
    @objc func swapLanguageButton(_ sender: UIButton?) {
        
        let chooseLanguageModel = ChooseLanguageModel.instance
        
        if chooseLanguageModel.getLanguage(languageType: .input).displayName == Constants.autodetectionIdentifier {
            return
        }
        
        let tempOutputLanguage = chooseLanguageModel.getLanguage(languageType: .output)
        
        chooseLanguageModel.setLanguage(languageType: .output, newValue: chooseLanguageModel.getLanguage(languageType: .input))
        chooseLanguageModel.setLanguage(languageType: .input, newValue: tempOutputLanguage)
        
        cameraWithOptionView.chooseLanguageView.buttonOfLanguageFromTranslate.setTitle(chooseLanguageModel.getLanguage(languageType: .input).displayName, for: .normal)
        cameraWithOptionView.chooseLanguageView.buttonOfTranslateIntoLanguage.setTitle(chooseLanguageModel.getLanguage(languageType: .output).displayName, for: .normal)
        
    }
    
    @objc func captureImage(_ sender: UIButton?) {
        self.takePicture = true
    }
    
    
//    @objc func toggleFlash(_ sender: UIButton?) {
//        do {
//            try self.cameraWithOptionView.cameraView.device.lockForConfiguration()
//            self.cameraWithOptionView.cameraView.device.torchMode = self.cameraWithOptionView.cameraView.device.torchMode == .on ? .off : .on
//            if self.cameraWithOptionView.cameraView.device.torchMode == .on {
//                try self.cameraWithOptionView.cameraView.device.setTorchModeOn(level: 1)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    //MARK: Navigation action
    @objc func openGallery(_ sender: UIButton?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.presentationController?.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            self.cameraWithOptionView.cameraView.session.stopRunning()
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
    
    
    func showImagePreview(image: UIImage) {
        let imagePreview = ImagePreviewController(currentMode: self.currentMode, image: image)
        
        if self.currentMode == .translation {
            imagePreview.modalPresentationStyle = .formSheet
        } else {
            imagePreview.modalPresentationStyle = .custom
            imagePreview.transitioningDelegate = self
        }
        self.present(imagePreview, animated: false)
    }
}


extension CameraViewController {
    func setupOutput() {
        cameraWithOptionView.cameraView.output = AVCaptureVideoDataOutput()
        
        let videoQueue = DispatchQueue(label: self.cameraWithOptionView.cameraView.videoQueueLabel, qos: .userInteractive)
        cameraWithOptionView.cameraView.output.setSampleBufferDelegate(self, queue: videoQueue)
        
        if cameraWithOptionView.cameraView.session.canAddOutput(cameraWithOptionView.cameraView.output) {
            cameraWithOptionView.cameraView.session.addOutput(cameraWithOptionView.cameraView.output)
        } else {
            fatalError("could not add video output")
        }
        
        
        cameraWithOptionView.cameraView.output.connections.first?.videoOrientation = .portrait
        
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


//MARK: - UIPicker Delegate
extension CameraViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cameraWithOptionView.modes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        modeLabel.textColor = .yellow
        modeLabel.text = self.cameraWithOptionView.modes[row].description
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return modeView
        
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentMode = self.cameraWithOptionView.modes[row]
    }
}

//MARK: IMagePicker Delegate
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.cameraWithOptionView.cameraView.session.startRunning()
        self.dismiss(animated: true)
        
        if let pickedImage = info[.originalImage] as? UIImage {
            self.showImagePreview(image: pickedImage)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.cameraWithOptionView.cameraView.session.startRunning()
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.dismiss(animated: true, completion: nil)
        self.cameraWithOptionView.cameraView.session.startRunning()
    }
}

//MARK:AVCaptureVideoDataOutputSampleBuffer Delegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        connection.videoOrientation = .portrait
        lastFrame = sampleBuffer
        
        
        if !takePicture {
            return
        }
        
        guard var uiImage = self.getCapturedImage() else { return }
        
        
        DispatchQueue.main.sync {
            
            uiImage = UIUtilities.cropImage(
                                uiImage,
                                toRect: self.cameraWithOptionView.cropBox.frame,
                                viewWidth: self.cameraWithOptionView.cameraView.frame.width,
                                viewHeight: self.cameraWithOptionView.cameraView.frame.height)

            self.showImagePreview(image: uiImage)
            self.takePicture = false
        }
    }

    private func getCapturedImage() -> UIImage? {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        let rotatedImage = UIImage(cgImage: cgImage)
        return rotatedImage
    }
}


//MARK:- VNDocumentCameraViewControllerDelegate
extension CameraViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        
        dismiss(animated: true, completion: nil)
        
        showImagePreview(image: image)
        
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Small sheet view delegate
extension CameraViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DrawerPresentationController(presentedViewController: presented, presenting: presenting)

        presentationController.cornerRadius = 20
        presentationController.roundedCorners = [.topLeft, .topRight]
        presentationController.topGap = 240
        presentationController.bounce = true
        return presentationController
     }
}
