//
//  CameraView.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import UIKit
import AVFoundation
import SnapKit




class CameraViewController: UIViewController {
    //MARK:- View Components
    let captureImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let openGalleryButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "photo")
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
    
    var takePicture: Bool = false
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(cameraView)
        
        self.configCameraViewConstraints()
        self.setupView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        self.setupOutput()
        
        
    }
    
    //MARK:- Actions
    @objc func captureImage(_ sender: UIButton?) {
        self.takePicture = true
    }
    
    @objc func openGallery(_ sender: UIButton?){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}


extension CameraViewController {
    //MARK:- View Setup
    func setupView(){
        view.backgroundColor = .black
        view.addSubview(captureImageButton)
        view.addSubview(openGalleryButton)
        
        
        captureImageButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(80)
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        openGalleryButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.left.equalTo(view.snp.left).offset(25)
        }
        
        
        
        captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        openGalleryButton.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        
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


