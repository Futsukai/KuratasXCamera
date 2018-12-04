//
//  KuratasXAlertView.swift
//  KuratasXCamera
//
//  Created by zhangwei on 2018/12/4.
//  Copyright © 2018年 Kuratasx. All rights reserved.
//

import UIKit

class KuratasXAlertView: UIView {
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.setLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout() {
        let button = UIButton()
        button.frame = UIScreen.main.bounds
        button.backgroundColor = .black
        button.alpha = 0.5
        self.addSubview(button)
        button.addTarget(self, action: #selector(didMissSelf), for: .touchDown)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 432))
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.center = self.center
        self.addSubview(view)
        
        let title = UILabel(frame: CGRect(x: 0, y: 40, width: 335, height: 25))
        title.textAlignment = .center
        title.text  = "拍摄提示"
        title.textColor = UIColor.init(hexColor: "#030303")
        title.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        view.addSubview(title)
        
        let msg = UILabel(frame: CGRect(x: 20,
                                        y: title.frame.maxY + 20,
                                        width: 295, height: 80))
        msg.textAlignment = .left
        msg.text  = "拍摄或上传一张照片，我们会通过您的照片创建您的智能替身，请保证拍照环境光线充足，面部无遮挡哦。"
        msg.textColor = UIColor.init(hexColor: "#030303")
        msg.numberOfLines = 0
        msg.lineBreakMode = .byWordWrapping
        msg.font = UIFont(name: "PingFangSC-Regular", size: 16)
        view.addSubview(msg)
        
        
        let imageView = UIImageView(image: UIImage(named: "Example"))
        imageView.frame = CGRect(x: 20, y: msg.frame.maxY + 18, width: 295, height: 130)
        view.addSubview(imageView)
        
        
        let  leftLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY + 13,
                                               width: view.bounds.width * 0.5 , height: 20))
        leftLabel.text = "对准参考线"
        leftLabel.textAlignment = .center
        leftLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        view.addSubview(leftLabel)
        
        
        let  rightLabel = UILabel(frame: CGRect(x: leftLabel.frame.maxX, y: imageView.frame.maxY + 13,
                                               width: view.bounds.width * 0.5 , height: 20))
        rightLabel.text = "不要笑哦"
        rightLabel.textAlignment = .center
        rightLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        view.addSubview(rightLabel)

        
        let btn = UIButton()
        btn.setTitle("知道了", for: .normal)
        btn.addTarget(self, action: #selector(didMissSelf), for: .touchDown)
        view.addSubview(btn)
        btn.frame = CGRect(x: 20, y: 362, width: 295, height: 50)
        
        
        
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = btn.bounds
        gradient.colors = [UIColor.init(hexColor: "B35BFF ").cgColor,UIColor.init(hexColor: "805FED").cgColor]
        gradient.cornerRadius = 25
        btn.layer.insertSublayer(gradient, at: 0)
        
    }
    func show(inView:UIView) {
        inView.addSubview(self)
    }
    @objc func didMissSelf() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.frame.origin.y = 1000
        }) { (didMiss) in
            self.removeFromSuperview()
        }
    }
    
}
