//
//  ViewController.swift
//  CommonKit
//
//  Created by wangpengyun on 09/10/2025.
//  Copyright (c) 2025 wangpengyun. All rights reserved.
//

import UIKit
import CommonKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage.createImage(with: UIColor.blue, rect: CGRect(x: 0, y: 0, width: 100, height: 100))

        let dragView = PYDragView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        dragView.isKeepCloseToBounds = true
        dragView.imageView.image = image//UIImage(named: "avatar")
        self.view.addSubview(dragView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

