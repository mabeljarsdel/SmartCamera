//
//  CameraView.swift
//  scannerApp
//
//  Created by Maksym on 02.12.2020.
//

import UIKit
import AVFoundation



class CameraView: UIView {
    var session: AVCaptureSession!
    var input: AVCaptureInput!
    var device: AVCaptureDevice!
    var preview: AVCaptureVideoPreviewLayer!
    var output: AVCaptureVideoDataOutput!
    
    let videoQueueLabel = "videoQueue"
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        preview?.frame = bounds
    }
    
    func setupAndStartCaptureSession(){
        
        DispatchQueue.global(qos: .userInitiated).async{
            self.session = AVCaptureSession()
            self.session.beginConfiguration()
            
            if self.session.canSetSessionPreset(.photo) {
                self.session.sessionPreset = .photo
            }
            
            self.session.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputs()
            
            DispatchQueue.main.sync {
                self.createPreview()
            }
            
            self.session.commitConfiguration()
            self.session.startRunning()
            self.output.alwaysDiscardsLateVideoFrames = true
        }
    }
    
    
    private func createPreview() {
        
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.bounds = bounds
        
        layer.addSublayer(preview)
    }
    
    func setupInputs() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            self.device = device
        } else {
            print("no back camera")
            return
        }
        
        guard let backInput = try? AVCaptureDeviceInput(device: device) else {
            print("could not create input device from back camera")
            return
        }
        
        if !session.canAddInput(backInput) {
            print("couldnt add back camera input")
            return
        }
        self.input = backInput
        session.addInput(backInput)
    }
    
}
