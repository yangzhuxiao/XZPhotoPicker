//
//  UIView+animations.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/23/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func oscillatoryAnimationWithLayer(layer: CALayer, max: CGFloat, min: CGFloat) {
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            layer.setValue(max, forKeyPath: "transform.scale")
            }, completion: { (finished) in
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    layer.setValue(min, forKeyPath: "transform.scale")
                    }, completion: { (finished) in
                        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            layer.setValue(1.0, forKeyPath: "transform.scale")
                            }, completion: { (finished) in
                        })
                })
        })
    }
}