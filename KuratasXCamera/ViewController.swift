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
        // Do any additional setup after loading the view, typically from a nib.
        let btn = UIButton()
        btn.setTitle("goooooo", for: .normal)
        self.view.addSubview(btn)
        
        btn.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        btn.addTarget(self, action: #selector(nextGo), for: .touchDown)
        btn.backgroundColor = .red
        
    }
    @objc func nextGo()  {
        self .present(KuratasxKuratasXViewController(), animated: true, completion: nil)
    }
    
}

