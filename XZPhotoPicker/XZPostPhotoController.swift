//
//  XZPostPhotoController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/23/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Photos

class XZPostPhotoController: UIViewController {
    private var tableView: UITableView?
    
    var timerAlbum: NSTimer?
    var timerCamera: NSTimer?
    var timerAlbumInCamera: NSTimer?

    var assetsArray: Array<XZAssetModel> = []
    
    init(assets: Array<XZAssetModel>) {
        self.assetsArray = assets
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        styleTableView()
    }
    
    func shouldReloadData() {
        self.assetsArray = SelectedAssets
        tableView!.reloadData()
    }
}

// MARK: Setup
private extension XZPostPhotoController {
    func setup() {
        func setupTableView() {
            if tableView == nil {
                tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight), style: UITableViewStyle.Plain)
                tableView?.registerClass(XZPostPhotoFirstCell.self, forCellReuseIdentifier: PostPhotoFirstCell_Identifier)
                tableView?.registerClass(XZPostPhotoLocationCell.self, forCellReuseIdentifier: PostPhotoLocationCell_Identifier)
                tableView?.dataSource = self
                tableView?.delegate = self
                view.addSubview(tableView!)
            }
        }
        func setupNavigationItems() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(XZPostPhotoController.cancelButtonPressed(_:)))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(XZPostPhotoController.sendButtonPressed(_:)))
        }
        setupTableView()
        setupNavigationItems()
    }
}


// MARK: Layout
private extension XZPostPhotoController {
    func layoutView() {
        func layoutTableView() {
            constrain(tableView!) { (view) in
                view.top == view.superview!.top
                view.bottom == view.superview!.bottom
                view.left == view.superview!.left
                view.right == view.superview!.right
            }
        }
    }
}

// MARK: Style
private extension XZPostPhotoController {
    func styleTableView() {
        tableView?.backgroundColor = UIColor.whiteColor()
        tableView?.tableFooterView = UIView()
    }
}

// MARK: UITableViewDataSource
extension XZPostPhotoController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(PostPhotoFirstCell_Identifier) as! XZPostPhotoFirstCell
            cell.assetModels = assetsArray
            
            weak var weakSelf = self
            cell.goToPostPreviewBlock = {(currentIndex: Int) -> () in
                let postPreviewVC = XZPostPhotoPreviewController(currentIndex: currentIndex, models: SelectedAssets)
                postPreviewVC.shouldReloadDataBlock = {() -> () in
                    weakSelf!.shouldReloadData()
                }
                weakSelf!.navigationController?.pushViewController(postPreviewVC, animated: true)
            }
            cell.addButtonPressedBlock = {() -> () in
                // 弹出alert
                let actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从手机相册选择", "拍照")
                actionSheet.showInView(weakSelf!.view)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(PostPhotoLocationCell_Identifier) as! XZPostPhotoLocationCell
            cell.setCellContentWithName("所在位置", icon: UIImage(named: "photoPreview_checkmark_checked"))
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(PostPhotoLocationCell_Identifier) as! XZPostPhotoLocationCell
            cell.setCellContentWithName("This is not supposed to show", icon: nil)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension XZPostPhotoController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            let rows: Int = assetsArray.count / 4 + 1
            return PostPhotoFirstCell_TextViewHeight + CGFloat(rows) * PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth + (CGFloat(rows) + 1) * PostPhoto_CollectionCellMargin + PostPhotoFirstCell_CollectionViewTopMargin
        case 1:
            return 44
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            // go to location page
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let cell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! XZPostPhotoFirstCell
        cell.textViewShouldResignFirstResponder()
    }
}

// MARK: UIActionSheetDelegate
extension XZPostPhotoController: UIActionSheetDelegate {
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
extension XZPostPhotoController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // go to setting
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
}

// MARK: Timer handler
extension XZPostPhotoController {
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
            UIImageWriteToSavedPhotosAlbum(originImage, self, #selector(XZPostPhotoController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
}

// MARK: Authorization
extension XZPostPhotoController {
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
                weakSelf!.timerAlbum = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(XZPostPhotoController.observeAlbumAuthorizationStatusChange), userInfo: nil, repeats: true)
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
                weakSelf!.timerCamera = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(XZPostPhotoController.observeCameraAuthorizationStatusChange), userInfo: nil, repeats: true)
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
        func alertViewWay() {
            let alert = UIAlertView(title: "无法访问手机相册", message: "请在iPhone的\"设置-隐私-照片\"选项中，\r允许访问你的手机相册", delegate: self, cancelButtonTitle: "取消")
            alert.addButtonWithTitle("设置")
            alert.show()
        }
        alertViewWay()
    }
    
    func goToCameraSetting() {
        func alertViewWay() {
            let alert = UIAlertView(title: "无法访问相机", message: "请在iPhone的\"设置-隐私-相机\"选项中，\r允许访问相机", delegate: self, cancelButtonTitle: "取消")
            alert.addButtonWithTitle("设置")
            alert.show()
        }
        alertViewWay()
    }
    
    func goToCameraRoll() {
        weak var weakSelf = self
        let albumVC = XZAlbumListController(isFromViewController: false)
        albumVC.shouldReloadDataBlock = {() -> () in
            weakSelf!.shouldReloadData()
        }
        let albumNav = UINavigationController(rootViewController: albumVC)
        
        if let cameraRollModel = XZImageManager.manager.getCameraRollAlbum() {
            let cameraRollVC: XZPhotoCollectionController = XZPhotoCollectionController(model: cameraRollModel, isFromViewController: false)
            cameraRollVC.shouldReloadDataBlock = {() -> () in
                weakSelf!.shouldReloadData()
            }
            albumNav.viewControllers.append(cameraRollVC)
            presentViewController(albumNav, animated: true, completion: nil)
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
            weakSelf!.shouldReloadData()
            weakSelf!.activityIndicator.stopAnimating()
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension XZPostPhotoController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        weak var weakSelf = self
        XZImageManager.manager.authorizationStatusForAlbum({
            weakSelf!.activityIndicator.startAnimating()
            let originImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(originImage, self, #selector(XZPostPhotoController.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }, notDetermined: {
                XZImageManager.manager.requestAuthorizationForAlbum()
                weakSelf!.timerAlbumInCamera = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(XZPostPhotoController.observeAlbumAuthorizationStatusChangeForCamera), userInfo: info, repeats: true)
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
extension XZPostPhotoController: UINavigationControllerDelegate {
    
}

// MARK: Actions
extension XZPostPhotoController {
    func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {
            EmptySelectedAssets()
        }
    }
    func sendButtonPressed(sender: UIBarButtonItem) {
        // TBD...
    }
}









