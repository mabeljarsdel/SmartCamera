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
    
    @objc func switchCamera(_ sender: UIButton?){
            
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
}


extension CameraViewController {
    //MARK:- View Setup
    func setupView(){
       view.backgroundColor = .black
       view.addSubview(captureImageButton)

        captureImageButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(80)
            make.bottom.equalTo(view.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
       
     captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        
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


extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
            let context = CIContext(options: nil)
            if context != nil {
                return context.createCGImage(inputImage, from: inputImage.extent)
            }
            return nil
        }
        
        if !takePicture {
            return //we have nothing to do with the image buffer
        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let cgImage = convertCIImageToCGImage(inputImage: ciImage)
        let uiImage = UIImage(cgImage: cgImage!)
        
        print(uiImage.imageOrientation.rawValue)
        
        self.takePicture = false
        DispatchQueue.main.sync {
            let imagePreview = ImagePreview()
            imagePreview.imageView = UIImageView(image: uiImage)
            
            imagePreview.modalPresentationStyle = .formSheet
            self.present(imagePreview, animated: true)
        }
        
        
    }
}


