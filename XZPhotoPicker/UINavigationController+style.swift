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
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = NavBgColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //        controller.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:NAV_TITLE_COLOR, NSFontAttributeName:NAV_TTTLE_FONT};
        
        
        navigationBar.translucent = false

    }
}
