//
//  ViewController.swift
//  KuratasXCamera
//
//  Created by zhangwei on 2018/11/28.
//  Copyright © 2018年 Kuratasx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.

        
//        let view = UIImageView(image: UIImage(named: "face"))
//        view.contentMode = .scaleAspectFit
//        self.view.addSubview(view)
//        view.frame = self.view.bounds
//        let image = KuratasXFaceDetector.beginDetectorFace(image: view.image!, inFrame: view.frame)
//        print(image.size)
//        view.image = image
        
        

        
        

        
        let btn = UIButton()
        btn.setTitle("goooooo", for: .normal)
        
        
        self.view.addSubview(btn)
        
        btn.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        btn.center = view.center

        btn.addTarget(self, action: #selector(nextGo), for: .touchDown)
        btn.backgroundColor = .red
        
    }
    @objc func nextGo()  {
        self.present(KuratasXViewController(hasUseImage: { (image, path) in
            print(image!)
            print(path!)
        }), animated: true, completion: nil)
    }
    func openURL() {
        if UIApplication.shared.canOpenURL(URL(string:"mtxx://")!){
            UIApplication.shared.open(URL(string:"mtxx://")!, options: [:], completionHandler: nil)
        }
    }
    
}

