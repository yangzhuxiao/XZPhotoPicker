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
    
    var timerAlbum: NSTimer?
    var timerCamera: NSTimer?
    var timerAlbumInCamera: NSTimer?

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
    }
}

// MARK: Actions
extension ViewController {
    func cameraButtonPressed(sender: UIBarButtonItem) {
//        date1 = NSDate()
        // old way - much faster
        oldActionSheetWay()
        // new way - significantly slower
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

// MARK: UIAlertViewDelegate
extension ViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // go to setting
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
}

// MARK: Timer handler
extension ViewController {
    func observeAlbumAuthorizationStatusChange() {
        if XZImageManager.manager.isAlbumAccessGranted() {
            timerAlbum?.invalidate()
            timerAlbum = nil
            
            activityIndicator.startAnimating()
            goToCameraRoll()
        }
    }
    func observeCameraAuthorizationStatusChange() {
        if XZImageManager.manager.isCameraAccessGranted() {
            timerCamera?.invalidate()
            timerCamera = nil
            
            takeAPhoto()
        }
    }
    func observeAlbumAuthorizationStatusChangeForCamera() {
        if XZImageManager.manager.isAlbumAccessGranted() {
            let originImage: UIImage = timerAlbumInCamera!.userInfo![UIImagePickerControllerOriginalImage] as! UIImage
            timerAlbumInCamera?.invalidate()
            timerAlbumInCamera = nil
            
            activityIndicator.startAnimating()
            UIImageWriteToSavedPhotosAlbum(originImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
}

// MARK: Settings
extension ViewController {
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
}

// MARK: Authorization
extension ViewController {
    func authorizationWithAlbum() {
        XZImageManager.manager.authorizationStatusForAlbum({
            // authorized
            // go to photo album
            weak var weakSelf = self
            weakSelf!.goToCameraRoll()
            }, notDetermined: {
                // 可能是第一次访问相册
                weak var weakSelf = self
                XZImageManager.manager.requestAuthorizationForAlbum()
                // 使用timer的原因是，实际对比时间发现，如果直接用PHPhotoLibrary.requestAuthorization方法的回调block，如果用户好几秒不点“同意”使用相册，则点击同意后，到present出来照片列表会花好几秒钟时间
                weakSelf!.timerAlbum = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.observeAlbumAuthorizationStatusChange), userInfo: nil, repeats: true)
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
            weak var weakSelf = self
            weakSelf!.takeAPhoto()
            }, notDetermined: {
                // 可能是第一次访问相机
                weak var weakSelf = self
                XZImageManager.manager.requestAuthorizationForCamera()
                weakSelf!.timerCamera = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.observeCameraAuthorizationStatusChange), userInfo: nil, repeats: true)
            }, restricted: {
                weak var weakSelf = self
                weakSelf!.goToCameraSetting()
        }) {
            // denied
            weak var weakSelf = self
            weakSelf!.goToCameraSetting()
        }
    }
    
    func goToCameraRoll() {
//        let date1 = NSDate()

        weak var weakSelf = self

        let albumVC = XZAlbumListController(isFromViewController: true)
        albumVC.shouldPresentPostVCBlock = {() -> () in
            let postVC: XZPostPhotoController = XZPostPhotoController(assets: SelectedAssets)
            let postNav = UINavigationController(rootViewController: postVC)
            weakSelf!.presentViewController(postNav, animated: true, completion: nil)
        }
        let albumNav = UINavigationController(rootViewController: albumVC)
        
        if let cameraRollModel = XZImageManager.manager.getCameraRollAlbum() {
            let cameraRollVC: XZPhotoCollectionController = XZPhotoCollectionController(model: cameraRollModel, isFromViewController: true)
            cameraRollVC.shouldPresentPostVCBlock = {() -> () in
                let postVC: XZPostPhotoController = XZPostPhotoController(assets: SelectedAssets)
                let postNav = UINavigationController(rootViewController: postVC)
                weakSelf!.presentViewController(postNav, animated: true, completion: nil)
            }
            albumNav.viewControllers.append(cameraRollVC)
            
//            let date2 = NSDate()
//            let duration = date2.timeIntervalSinceDate(date1)
//            print("present started time duration: \(duration)")
            
            presentViewController(albumNav, animated: true, completion: {
                
//                let date2 = NSDate()
//                let duration = date2.timeIntervalSinceDate(date1)
//                print("present finished time duration: \(duration)")
                
                weakSelf!.activityIndicator.stopAnimating()
            })
        }
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
    
    func image(image: UIImage, didFinishSavingWithError error: NSError, contextInfo info: UnsafePointer<Void>) {
        weak var weakSelf = self
        let newAssetModel: XZAssetModel = XZImageManager.manager.getLastPhotoFromCameraRoll()
        AddAssetModelToSelected(newAssetModel, { (fail) in
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
        
        dismissViewControllerAnimated(true, completion: nil)
        
        weak var weakSelf = self
        XZImageManager.manager.authorizationStatusForAlbum({ 
            weakSelf!.activityIndicator.startAnimating()
            let originImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(originImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }, notDetermined: { 
                XZImageManager.manager.requestAuthorizationForAlbum()
                weakSelf!.timerAlbumInCamera = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.observeAlbumAuthorizationStatusChangeForCamera), userInfo: info, repeats: true)
            }, restricted: { 
                weak var weakSelf = self
                weakSelf!.goToAlbumSetting()
            }) { 
                weak var weakSelf = self
                weakSelf!.goToAlbumSetting()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: 
extension ViewController: UINavigationControllerDelegate {
    
}











