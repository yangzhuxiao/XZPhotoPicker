//
//  UINavigationController+style.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/25/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = NavBgColor
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.translucent = false
        
        LightContentStatusBar()
    }
}
