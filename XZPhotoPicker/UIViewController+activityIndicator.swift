//
//  UIViewController+activityIndicator.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/27/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public var activityIndicator: UIActivityIndicatorView {
        get {
            dispatch_once(&Static.onceToke) {
                Static.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//                Static.activityIndicator?.backgroundColor = UIColor.blueColor()
                
            }
            return Static.activityIndicator!
        }
    }
    private struct Static {
        static var onceToke: dispatch_once_t = 0
        static var activityIndicator: UIActivityIndicatorView?
    }
}
