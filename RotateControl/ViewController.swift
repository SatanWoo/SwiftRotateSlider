//
//  ViewController.swift
//  RotateControl
//
//  Created by z on 15/10/26.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = WZRotateSlider(
            frame: self.view.bounds,
            0,
            UIColor.redColor(),
            UIColor.blueColor()
        )
        
        slider.center = CGPoint(
            x: self.view.frame.size.width/2,
            y: self.view.frame.size.height/2
        )
        
        self.view.addSubview(slider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

