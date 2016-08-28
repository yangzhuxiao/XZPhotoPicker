//
//  UIViewController+activityIndicator.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/27/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography

extension UIViewController {
    public var activityIndicator: UIActivityIndicatorView {
        get {
            dispatch_once(&Static.onceToke) {
                Static.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                Static.activityIndicator?.backgroundColor = RGBA(0, green: 0, blue: 0, alpha: 0.3)
                self.view.addSubview(Static.activityIndicator!)
                
                constrain(Static.activityIndicator!, block: { (view) in
                    view.centerX == view.superview!.centerX
                    view.centerY == view.superview!.centerY
                    view.width == 100
                    view.height == 100
                })
                Static.activityIndicator?.layer.cornerRadius = 5.0
                Static.activityIndicator?.layer.masksToBounds = true
            }
            return Static.activityIndicator!
        }
    }
    
    private struct Static {
        static var onceToke: dispatch_once_t = 0
        static var activityIndicator: UIActivityIndicatorView?
    }
}



