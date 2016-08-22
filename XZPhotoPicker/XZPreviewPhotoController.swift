//
//  XZPreviewPhotoController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/22/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZPreviewPhotoController: UIViewController {
    var models: Array<XZAssetModel>
    var photos: Array<PHAsset> = []
    var currentIndex: Int
    
    private var collectionView: UICollectionView?
    
    private let navBarView = UIView()
    private let backButton = UIButton()
    private let checkmarkButton = UIButton()
    
    private let toolBarView = UIView()
    private let okButton = UIButton()
    private let numberOfSelectedLabel = UILabel()
    private let circleOfNumberImageView = UIView()
    
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
        setup()
        layoutView()
        style()
    }
}

// MARK: Setup
private extension XZPreviewPhotoController {
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
                collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout())
                collectionView?.registerClass(XZPreviewPhotoCell.self, forCellWithReuseIdentifier: PhotoPreviewCell_Identifier)
                collectionView?.dataSource = self
                view.addSubview(collectionView!)
            }
        }
        
        func setupNavBarView() {
            
        }
        
        func setupToolBarView() {
            view.addSubview(toolBarView)
        }
        
        setupCollectinView()
        setupNavBarView()
        setupToolBarView()
    }
    
    
}

// MARK: Layout
private extension XZPreviewPhotoController {
    func layoutView() {
        constrain(toolBarView) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right + 1
            view.bottom == view.superview!.bottom
            view.height == PhotoPreview_BottomToolBarHeight
        }
        constrain(collectionView!, toolBarView) { (view1, view2) in
            view1.top == view1.superview!.top
            view1.left == view1.superview!.left
            view1.right == view1.superview!.right
            view1.bottom == view2.top
        }
    }
}

// MARK: Style
private extension XZPreviewPhotoController {
    func style() {
        
    }
}

// MARK: UICollectionViewDataSource
extension XZPreviewPhotoController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoPreviewCell_Identifier, forIndexPath: indexPath) as! XZPreviewPhotoCell
        cell.model = models[indexPath.row]
        return cell
    }
}


















