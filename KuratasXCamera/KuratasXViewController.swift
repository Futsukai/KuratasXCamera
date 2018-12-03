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
        view.backgroundColor = .black
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
        device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                         for: AVMediaType.video,
                                         position: .front)
        if device != nil{
            input = try? AVCaptureDeviceInput(device: device!)
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
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        lable.backgroundColor = UIColor.black
        lable.text = "拍照"
        lable.textColor = .white
        lable.textAlignment = .center
        lable.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        self.view.addSubview(lable)
        
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "CameraClose"), for: .normal)
        closeBtn.frame = CGRect(x: 20, y: 14, width: 16, height: 16)
        self.view.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeCamera), for: .touchDown)

        
        let remakeBtn = UIButton()
        remakeBtn.setImage(UIImage(named: "Issue"), for: .normal)
        remakeBtn.setImage(UIImage(), for: .selected)
        remakeBtn.setTitle("重拍", for: .selected)
        remakeBtn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        remakeBtn.frame = CGRect(x: self.view.bounds.width - 17 - 34, y: 14, width: 34, height: 24)
        self.view.addSubview(remakeBtn)
        remakeBtn.addTarget(self, action: #selector(remakeCamera(btn:)), for: .touchDown)
        
        
        let height:CGFloat  =  123.0
        let maskView = UIImageView(image: UIImage(named: "MaskImage"))
        self.view.addSubview(maskView)
        maskView.frame = CGRect(x: 0,
                                y: lable.frame.maxY,
                                width: self.view.bounds.width,
                                height: self.view.bounds.height - lable.frame.maxY - height)
        
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0,
                                  y: self.view.bounds.height - height,
                                  width: self.view.bounds.width,
                                  height: height)
        bottomView.backgroundColor = UIColor.black
        self.view.addSubview(bottomView)
        
        
        let takeButton = UIButton()
        takeButton.setImage(UIImage(named: "CameraDown"), for: .normal)
        takeButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        bottomView.addSubview(takeButton)
        takeButton.center = bottomView.realCenter
        takeButton.addTarget(self, action: #selector(takePhoto), for: .touchDown)
        
        
        let upLoadBtn = UIButton()
        upLoadBtn.setImage(UIImage(named: "UpImage"), for: .normal)
        upLoadBtn.frame = CGRect(x: 50, y: 0, width: 50, height: 50)
        upLoadBtn.center.y = bottomView.realCenter.y
        bottomView.addSubview(upLoadBtn)
        upLoadBtn.addTarget(self, action: #selector(upLoad), for: .touchDown)

        
        let switchBtn = UIButton()
        switchBtn.setImage(UIImage(named: "CameraSwitch"), for: .normal)
        switchBtn.frame = CGRect(x: bottomView.bounds.size.width - 100, y: 0, width: 50, height: 50)
        switchBtn.center.y = bottomView.realCenter.y
        bottomView.addSubview(switchBtn)
        switchBtn.addTarget(self, action: #selector(cameraSwitch), for: .touchDown)
        

        
        tempView.isHidden = true
        tempView.frame = self.view.bounds
        tempView.backgroundColor = .yellow
        tempView.contentMode = .scaleAspectFit
        self.view.addSubview(tempView)
    }
    
    //MARK: - Btn touchDown
    @objc func takePhoto() {
        let connection = imageOutPut?.connection(with: AVMediaType.video)
        guard connection != nil else {
            return
        }
        imageOutPut?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    @objc func upLoad() {
   
    }
    @objc func cameraSwitch(){
        changeCamera()
    }
    
    @objc func closeCamera(){
        self.dismiss(animated: true, completion: nil)
    }
    //TODO: remakeCamera is not realization
    @objc func remakeCamera(btn:UIButton){
        btn.isSelected = !btn.isSelected
    }

    func changeCamera() {
        let animation = CATransition()
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type =  CATransitionType(rawValue: "oglFlip")
        let position = self.device?.position
        if  position == AVCaptureDevice.Position.front {
            device = cameraWithPosition(position: .back)
            animation.subtype = CATransitionSubtype.fromLeft
        }else{
            device = cameraWithPosition(position: .front)
            animation.subtype = CATransitionSubtype.fromRight
        }
        self.previewLayer!.add(animation, forKey: nil)
        self.session?.stopRunning()
        self.session?.removeInput(input!)
        input = try? AVCaptureDeviceInput(device: device!)
        guard input != nil else { return }
        if true == session?.canAddInput(input!){
            session?.addInput(input!)
        }
        session?.commitConfiguration()
        session?.startRunning()
    }
    func cameraWithPosition(position:AVCaptureDevice.Position) -> AVCaptureDevice? {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
        for device in session.devices {
            if device.position == position {
                return device
            }
        }
        return nil
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
    override var prefersStatusBarHidden: Bool{
        return true
    }
}




extension UIView {
    var realCenter:CGPoint {
        return  self.convert(self.center, from: self.superview)
    }
}
