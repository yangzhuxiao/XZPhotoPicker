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

// MARK: Actions
extension XZPostPhotoController {
    func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {
            emptySelectedAssets()
        }
    }
    func sendButtonPressed(sender: UIBarButtonItem) {
        // TBD...
    }
}









