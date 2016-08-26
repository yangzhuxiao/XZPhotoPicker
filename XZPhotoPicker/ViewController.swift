//
//  ViewController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/25/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class ViewController: UIViewController {
//    private var date1: NSDate?
//    private var date2: NSDate?
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray  )
    private var showPostVC = {() -> () in }
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
        
        setupActivityIndicator()
        layoutActivityIndicator()
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
    }
}

// MARK: Layout
private extension ViewController {
    func layoutActivityIndicator() {
        constrain(activityIndicator) { (view) in
            view.centerX == view.superview!.centerX
            view.centerY == view.superview!.centerY
            view.width == 100
            view.height == 100
        }
    }
}

// MARK: Actions
extension ViewController {
    func cameraButtonPressed(sender: UIBarButtonItem) {
        
//        date1 = NSDate()
        
        // old way - much faster
        oldActionSheetWay()
        
        // new way
//        newAlertControllerWay()
    }
    
    func oldActionSheetWay() {
        let oldActionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从手机相册选择", "拍照")
        oldActionSheet.showInView(view)
    }
    
    func newAlertControllerWay() {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        weak var weakSelf = self
        let albumAction = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.Default) { (action) in
            weakSelf!.authorizationWithAlbum()
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

// MARK: UIActionSheetDelegate
extension ViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // go to album
            authorizationWithAlbum()
        } else if buttonIndex == 2 {
            // go to take a picture
            authorizationWithCamera()
        }
    }
}

// MARK: 
extension ViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // go to setting
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
}

// MARK: Authorization
extension ViewController {
    func authorizationWithAlbum() {
        XZImageManager.manager.authorizationStatusForAlbum({
            // authorized
            // go to photo album
            weak var weakSelf = self
            weakSelf!.goToAlbum()
            }, notDetermined: {
                // 可能是第一次访问相册
                weak var weakSelf = self
                weakSelf!.goToAlbumSetting()
            }, restricted: {
                weak var weakSelf = self
                weakSelf!.goToAlbumSetting()
        }) {
            // denied
            weak var weakSelf = self
            weakSelf!.goToAlbumSetting()
        }
    }
    
    func authorizationWithCamera() {
        XZImageManager.manager.authorizationStatusForCamera({ 
            // authorized
            // turn on camera
            print("camera roll images count before taking photo: \(XZImageManager.manager.getCameraRollAlbum()?.count)")
            weak var weakSelf = self
            weakSelf!.takeAPhoto()
            }, notDetermined: {
                // 可能是第一次访问相机
                print("camera roll images count before taking photo: \(XZImageManager.manager.getCameraRollAlbum()?.count)")
                weak var weakSelf = self
                weakSelf!.takeAPhoto()
            }, restricted: { 
                weak var weakSelf = self
                weakSelf!.goToCameraSetting()
        }) {
            // denied
            weak var weakSelf = self
            weakSelf!.goToCameraSetting()
        }
    }
    
    func goToAlbumSetting() {
        // new way
        func alertControllerWay() {
            let alertController = UIAlertController(title: "无法访问手机相册", message: "请在iPhone的\"设置-隐私-照片\"选项中，\r允许访问你的手机相册", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel =  UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
            let goToSetting = UIAlertAction(title: "设置", style: UIAlertActionStyle.Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            })
            alertController.addAction(cancel)
            alertController.addAction(goToSetting)
            presentViewController(alertController, animated: true, completion: nil)
        }
        // old way
        func alertViewWay() {
            let alert = UIAlertView(title: "无法访问手机相册", message: "请在iPhone的\"设置-隐私-照片\"选项中，\r允许访问你的手机相册", delegate: self, cancelButtonTitle: "取消")
            alert.addButtonWithTitle("设置")
            alert.show()
        }
        
//        alertControllerWay()
        alertViewWay()
    }
    
    func goToCameraSetting() {
        // new way
        func alertControllerWay() {
            let alertController = UIAlertController(title: "无法访问相机", message: "请在iPhone的\"设置-隐私-相机\"选项中，\r允许访问相机", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel =  UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
            let goToSetting = UIAlertAction(title: "设置", style: UIAlertActionStyle.Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            })
            alertController.addAction(cancel)
            alertController.addAction(goToSetting)
            presentViewController(alertController, animated: true, completion: nil)
        }
        // old way
        func alertViewWay() {
            let alert = UIAlertView(title: "无法访问相机", message: "请在iPhone的\"设置-隐私-相机\"选项中，\r允许访问相机", delegate: self, cancelButtonTitle: "取消")
            alert.addButtonWithTitle("设置")
            alert.show()
        }
        
//        alertControllerWay()
        alertViewWay()
    }
    
    func goToAlbum() {
        let albumVC = XZAlbumListController()
        let albumNav = UINavigationController(rootViewController: albumVC)
        presentViewController(albumNav, animated: true, completion: {
//                self.date2 = NSDate()
//                let timeInterval = self.date2!.timeIntervalSinceDate(self.date1!)
//                print("time interval is: \(timeInterval)")
        })
    }
    
    func takeAPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerVC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            imagePickerVC.delegate = self
            presentViewController(imagePickerVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "无法访问相机", message: nil, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    func getLastPhoto() {
//        let newAssetModel: XZAssetModel = XZImageManager.manager.getLastPhotoFromCameraRoll()
        
        print("camera roll images count after taking photo: \(XZImageManager.manager.getCameraRollAlbum()?.count)")
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo info: UnsafePointer<Void>) {
        weak var weakSelf = self
        let newAssetModel: XZAssetModel = XZImageManager.manager.getLastPhotoFromCameraRoll()
        addAssetModelToSelected(newAssetModel, { (fail) in
            
            weakSelf!.activityIndicator.stopAnimating()

            }) { (success) in
                
                // present Post VC
                let postVC: XZPostPhotoController = XZPostPhotoController(assets: SelectedAssets)
                let postNav = UINavigationController(rootViewController: postVC)
                weakSelf!.presentViewController(postNav, animated: true, completion: {
                    weakSelf!.activityIndicator.stopAnimating()
                })
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        activityIndicator.startAnimating()
        
        dismissViewControllerAnimated(true, completion: nil)
        let originImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("origin Image Size: (width: \(originImage.size.width), (height: \(originImage.size.height)))")
        UIImageWriteToSavedPhotosAlbum(originImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: 
extension ViewController: UINavigationControllerDelegate {
    
}











