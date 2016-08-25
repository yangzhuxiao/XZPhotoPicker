//
//  ViewController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/25/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "发现"
        view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: #selector(ViewController.cameraButtonPressed(_:)))
    }
    
}

// MARK: Actions
extension ViewController {
    func cameraButtonPressed(sender: UIBarButtonItem) {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let albumAction = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.Default) { (action) in
            XZImageManager.manager.authorizationStatus({
                // authorized
                let albumVC = XZAlbumListController()
                let albumNav = UINavigationController(rootViewController: albumVC)
                self.presentViewController(albumNav, animated: true, completion: {
                })
                }, notDetermined: {
                    // notDetermined
                    let alert = UIAlertView(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\r允许访问你的手机相册", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }, restricted: {
                    // restricted
                    let alert = UIAlertView(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\r允许访问你的手机相册", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
            }) {
                // denied
                let alert = UIAlertView(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\r允许访问你的手机相册", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            // go to photo album
        }
        let photoAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (action) in
            // take a picture
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action) in
            // dismiss action sheet
        }
        actionsheet.addAction(albumAction)
        actionsheet.addAction(photoAction)
        actionsheet.addAction(cancelAction)
        
        self.presentViewController(actionsheet, animated: true) {
        }
    }
}











