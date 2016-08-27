//
//  XZPostPhotoPreviewController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/27/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZPostPhotoPreviewController: UIViewController {
    var models: Array<XZAssetModel>
    var currentIndex: Int = 0
    private var collectionView: UICollectionView?
    private var cvYOrigin: CGFloat = 0
    
    required init(currentIndex: Int, models: Array<XZAssetModel>) {
        self.models = models
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        layoutView()
        style()
        moveToCurrentIndex()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // refresh post view
        let postVC = self.navigationController!.topViewController as! XZPostPhotoController // already poped from stack
        postVC.shouldReloadData()
    }
    
    func moveToCurrentIndex() {
        collectionView?.setContentOffset(CGPointMake(ScreenWidth * CGFloat(currentIndex), 0), animated: false)
    }
}

// MARK: Setup
private extension XZPostPhotoPreviewController {
    func setup() {
        func setupCollectinView() {
            func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
                flowLayout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                return flowLayout
            }
            if collectionView == nil {
                cvYOrigin = -self.navigationController!.navigationBar.frame.size.height - StatusBarHeight

                collectionView = UICollectionView(frame: CGRectMake(0, cvYOrigin, ScreenWidth, ScreenHeight), collectionViewLayout: collectionViewFlowLayout())
                collectionView?.registerClass(XZPreviewPhotoCell.self, forCellWithReuseIdentifier: PhotoPreviewCell_Identifier)
                collectionView?.contentSize = CGSize(width: CGFloat(models.count) * ScreenWidth, height: 0)
                collectionView?.dataSource = self
                collectionView?.delegate = self
                view.addSubview(collectionView!)
            }
        }
        
        func setupNaviBar() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: #selector(XZPostPhotoPreviewController.trashButtonPressed(_:)))
        }
        
        setupCollectinView()
        setupNaviBar()
    }
}

// MARK: Layout
private extension XZPostPhotoPreviewController {
    func layoutView() {
        constrain(collectionView!) { (view) in
        }
    }
}

// MARK: Style
private extension XZPostPhotoPreviewController {
    func style() {
        func styleCollectionView() {
            collectionView?.pagingEnabled = true
        }
        func styleNaviBar() {
        }
        
        styleCollectionView()
        styleNaviBar()
        refreshNaviTitle()
    }
    
    func toggleNaviBarDisplayStatus() {
        if navigationController?.navigationBarHidden == true {
            UIView.animateWithDuration(0.2, animations: {
                self.navigationController!.navigationBarHidden = false
                self.collectionView!.frame = CGRectOffset(self.collectionView!.frame, 0, self.cvYOrigin)
                ShowStatusbar()
                }, completion: { (success) in
            })
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.navigationController!.navigationBarHidden = true
                self.collectionView!.frame = CGRectOffset(self.collectionView!.frame, 0, -self.cvYOrigin)
                HideStatusbar()
                }, completion: { (success) in
            })
        }
    }
    
    func refreshNaviTitle() {
        navigationItem.title = String(currentIndex + 1) + "/" + String(models.count)
    }
}

// MARK: UICollectionViewDataSource
extension XZPostPhotoPreviewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoPreviewCell_Identifier, forIndexPath: indexPath) as! XZPreviewPhotoCell
        cell.model = models[indexPath.row]
        
        weak var weakSelf = self
        cell.singleTapGestureBlock = {() -> () in
            // TBD... show/hide toolbar and navBar
            weakSelf!.toggleNaviBarDisplayStatus()
        }
        return cell
    }
}

// MARK: UIScrollViewDelegate
extension XZPostPhotoPreviewController: UICollectionViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let theIndex = Int(round(offsetX/ScreenWidth))
        
        if theIndex != currentIndex {
            currentIndex = theIndex
            refreshNaviTitle()
        }
    }
}

// MARK: Actions
extension XZPostPhotoPreviewController {
    func trashButtonPressed(sender: UIBarButtonItem) {
        let currentModel: XZAssetModel = models[currentIndex]
        weak var weakSelf = self
        RemoveAsset(currentModel.asset) { (success) in
            if SelectedAssets.count == 0 {
                weakSelf!.navigationController!.popViewControllerAnimated(true)
                return
            }
            weakSelf!.models = SelectedAssets
            weakSelf!.collectionView!.reloadData()
            weakSelf!.refreshNaviTitle()
            weakSelf!.moveToCurrentIndex()
        }
    }
}


