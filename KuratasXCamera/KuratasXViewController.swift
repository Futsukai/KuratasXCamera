//
//  KuratasxKuratasXViewController.swift
//  KuratasXCamera
//
//  Created by zhangwei on 2018/11/28.
//  Copyright © 2018年 Kuratasx. All rights reserved.
//

import UIKit
import Photos

class KuratasXViewController: UIViewController,
AVCapturePhotoCaptureDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    public typealias useCallBack = (UIImage?, String?) -> Void

    private var iamgeView: UIImageView?
    private var remakeBtn: UIButton?
    private var upLoadBtn: UIButton?
    private var takeButton: UIButton?
    private var switchBtn: UIButton?
    private var useImageBtn: UIButton?
    
    private var device:AVCaptureDevice?
    private var input:AVCaptureInput?
    private var imageOutPut:AVCapturePhotoOutput?
    private var session:AVCaptureSession?
    private var previewLayer:AVCaptureVideoPreviewLayer?
    private var imagePath:String?
    private var callBack:useCallBack?

    init(hasUseImage:@escaping useCallBack) {
        super.init(nibName: nil, bundle: nil)
        self.callBack = hasUseImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        self.remakeBtn = remakeBtn
        
        let height:CGFloat  =  123.0
        let maskView = UIImageView(image: UIImage(named: "MaskImage"))
        self.view.addSubview(maskView)
        maskView.frame = CGRect(x: 0,
                                y: lable.frame.maxY,
                                width: self.view.bounds.width,
                                height: self.view.bounds.height - lable.frame.maxY - height)
        self.iamgeView = maskView
        
        
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
        self.takeButton = takeButton

        
        let upLoadBtn = UIButton()
        upLoadBtn.setImage(UIImage(named: "UpImage"), for: .normal)
        upLoadBtn.frame = CGRect(x: 50, y: 0, width: 50, height: 50)
        upLoadBtn.center.y = bottomView.realCenter.y
        bottomView.addSubview(upLoadBtn)
        upLoadBtn.addTarget(self, action: #selector(upLoad), for: .touchDown)
        self.upLoadBtn = upLoadBtn

        
        let switchBtn = UIButton()
        switchBtn.setImage(UIImage(named: "CameraSwitch"), for: .normal)
        switchBtn.frame = CGRect(x: bottomView.bounds.size.width - 100, y: 0, width: 50, height: 50)
        switchBtn.center.y = bottomView.realCenter.y
        bottomView.addSubview(switchBtn)
        switchBtn.addTarget(self, action: #selector(cameraSwitch), for: .touchDown)
        self.switchBtn = switchBtn

        let useImageBtn = UIButton()
        useImageBtn.setTitle("立即创建", for: .normal)
        useImageBtn.frame = CGRect(x: 20, y: 0, width: self.view.bounds.width - 40, height: 50)
        useImageBtn.center.y = bottomView.realCenter.y
        bottomView.addSubview(useImageBtn)
        useImageBtn.addTarget(self, action: #selector(useImage), for: .touchDown)
        self.useImageBtn = useImageBtn
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = useImageBtn.bounds
        gradient.colors = [UIColor.init(hexColor: "B35BFF ").cgColor,UIColor.init(hexColor: "805FED").cgColor]
        gradient.cornerRadius = 25
        useImageBtn.layer.insertSublayer(gradient, at: 0)
        useImageBtn.isHidden = true

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
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }else{
            debugPrint("---------->> \(#file):\(#line) \(#function)<<---------")
        }
    }
    @objc func cameraSwitch(){
        changeCamera()
    }
    
    @objc func closeCamera(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func remakeCamera(btn:UIButton){
        if btn.isSelected {
            self.switchState(hasImage: false)
        }else{
            let alert = KuratasXAlertView()
            alert.show(inView: UIApplication.shared.keyWindow!)
        }
    }
    @objc func useImage(){
        self.dismiss(animated: true) {
            debugPrint("use image")
            self.callBack?(self.iamgeView?.image,self.imagePath)
        }
    }
    func changeCamera() {
        let position = self.device?.position
        if  position == AVCaptureDevice.Position.front {
            device = cameraWithPosition(position: .back)
        }else{
            device = cameraWithPosition(position: .front)
        }
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
    //MARK: -  UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] {
                self.iamgeView?.image = (image as! UIImage)
                self.saveImageToDocumentDirectory(image: self.iamgeView!.image! )
                self.switchState(hasImage: true)
            }
        }
    }
    
    //MARK: -  AVCapturePhotoCaptureDelegate
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }else{
            if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer){
                self.iamgeView!.image =  UIImage(data: imageData)!
                saveImageToDocumentDirectory(image: self.iamgeView!.image! )
                self.switchState(hasImage: true)
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
    func saveImageToDocumentDirectory(image:UIImage) {
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(rootPath)/KuratasXFaceImage.jpg"
        let imageData = image.jpegData(compressionQuality: 0.8)
        FileManager.default.createFile(atPath: filePath, contents: imageData, attributes: nil)
        debugPrint(filePath)
        self.imagePath = filePath
    }
 
    func switchState(hasImage:Bool) {
        if hasImage {
            remakeBtn?.isHidden = false
            remakeBtn?.isSelected = true
            upLoadBtn?.isHidden = true
            switchBtn?.isHidden = true
            takeButton?.isHidden = true
            useImageBtn?.isHidden = false
        }else{
            remakeBtn?.isHidden = false
            upLoadBtn?.isHidden = false
            switchBtn?.isHidden = false
            takeButton?.isHidden = false
            iamgeView?.image = UIImage(named: "MaskImage")
            useImageBtn?.isHidden = true
        }
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
extension UIColor {
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    convenience init(hexColor: String) {
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        // 分别转换进行转换
        Scanner(string: hexColor[0..<2]).scanHexInt32(&red)
        Scanner(string: hexColor[2..<4]).scanHexInt32(&green)
        Scanner(string: hexColor[4..<6]).scanHexInt32(&blue)
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
