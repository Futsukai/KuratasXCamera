//
//  KuratasxKuratasXViewController.swift
//  KuratasXCamera
//
//  Created by zhangwei on 2018/11/28.
//  Copyright © 2018年 Kuratasx. All rights reserved.
//

import UIKit
import Photos

class KuratasXViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var device:AVCaptureDevice?
    var input:AVCaptureInput?
    var imageOutPut:AVCapturePhotoOutput?
    var session:AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer?
    let tempView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        checkUserCamear()
    }
    func checkUserCamear() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { success in
            DispatchQueue.main.async {
                if !success {
                    self.showAlert()
                }else{
                    self.cameraSetup()
                    self.displaySetup()
                }
            }
            
        }
    }
    func cameraSetup() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: AVMediaType.video,
                                                position: .front){
            input = try? AVCaptureDeviceInput(device: device)
            guard input != nil else { return }
            imageOutPut = AVCapturePhotoOutput()
            session = AVCaptureSession()
            session?.beginConfiguration()
            session?.sessionPreset = AVCaptureSession.Preset.photo
            if true == session?.canAddInput(input!){
                session?.addInput(input!)
            }
            if true == session?.canAddOutput(imageOutPut!){
                session?.addOutput(imageOutPut!)
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: session!)
            previewLayer?.frame = view.bounds
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            view.layer.addSublayer(previewLayer!)
            session?.commitConfiguration()
            session?.startRunning()            
        }
    }
    func displaySetup() {
        let takeButton = UIButton()
        takeButton.setTitle("take", for: .normal)
        takeButton.frame = CGRect(x: 100, y: 300, width: 60, height: 60)
        takeButton.backgroundColor = .white
        self.view.addSubview(takeButton)
        takeButton.addTarget(self, action: #selector(takePhoto), for: .touchDown)
        
        tempView.isHidden = true
        tempView.frame = self.view.bounds
        tempView.backgroundColor = .yellow
        tempView.contentMode = .scaleAspectFit
        self.view.addSubview(tempView)
    }
    @objc func takePhoto() {
        let connection = imageOutPut?.connection(with: AVMediaType.video)
        guard connection != nil else {
            return
        }
        imageOutPut?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    //MARK: -  AVCapturePhotoCaptureDelegate
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }else{
            if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer){
                self.tempView.image = KuratasXFaceDetector.beginDetectorFace(image: UIImage(data: imageData)!, inFrame: self.tempView.bounds)
//                self.tempView.image = KuratasXFaceDetector.remark(image: UIImage(data: imageData)!, to: self.tempView.bounds.size)

                tempView.isHidden = false
            }
        }
    }
    func showAlert() {
        let alertView = UIAlertController(title: "请打开相机权限",
                                          message: "Test",
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "了解",
                                          style: .cancel,
                                          handler: { (action) in
                                            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
}
