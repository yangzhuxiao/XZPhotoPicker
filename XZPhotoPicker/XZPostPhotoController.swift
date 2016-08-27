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

// MARK: 
extension XZPostPhotoController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 2
//        default:
//            return 2
//        }
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PostPhotoFirstCell_Identifier) as! XZPostPhotoFirstCell
        cell.assetModels = assetsArray
        
        weak var weakSelf = self
        cell.goToPostPreviewBlock = {(currentIndex: Int) -> () in
            let postPreviewVC = XZPostPhotoPreviewController(currentIndex: currentIndex, models: SelectedAssets)
            weakSelf!.navigationController?.pushViewController(postPreviewVC, animated: true)
        }
        cell.addButtonPressedBlock = {(leftMaxPhotosCount: Int) -> () in
            // 弹出alert
            let actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从手机相册选择", "拍照")
            actionSheet.showInView(weakSelf!.view)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension XZPostPhotoController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rows: Int = assetsArray.count / 4 + 1
        return PostPhotoFirstCell_TextViewHeight + CGFloat(rows) * PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth + (CGFloat(rows) + 1) * PostPhoto_CollectionCellMargin + PostPhotoFirstCell_CollectionViewTopMargin
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

// MARK:
extension XZPostPhotoController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            // go to setting
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
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
            weak var weakSelf = self
            weakSelf!.takeAPhoto()
            }, notDetermined: {
                // 可能是第一次访问相机
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
    
    func goToAlbum() {
        let albumVC = XZAlbumListController()
        let albumNav = UINavigationController(rootViewController: albumVC)
        presentViewController(albumNav, animated: true, completion: nil)
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
extension XZPostPhotoController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        activityIndicator.startAnimating()
        
        dismissViewControllerAnimated(true, completion: nil)
        let originImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        print("origin Image Size: (width: \(originImage.size.width), (height: \(originImage.size.height)))")
        UIImageWriteToSavedPhotosAlbum(originImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
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









