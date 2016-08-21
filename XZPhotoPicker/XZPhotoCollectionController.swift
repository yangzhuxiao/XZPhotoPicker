//
//  XZPhotoCollectionController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/20/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Photos

class XZPhotoCollectionController: UIViewController {
    private var collectionView: UICollectionView?
    var model: XZAlbumModel
    
    required init(model: XZAlbumModel) {
        self.model = model
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
private extension XZPhotoCollectionController {
    func setup() {
        title = model.name
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
            let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: CGFloat(PhotoCollectionCell_PhotoWidth),
                                         height: CGFloat(PhotoCollectionCell_PhotoWidth))
            flowLayout.minimumInteritemSpacing = PhotoCollectionCell_XMargin
            flowLayout.minimumLineSpacing = PhotoCollectionCell_XMargin
            return flowLayout
        }
        
        if collectionView == nil {
            collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout())
            collectionView!.dataSource = self
            collectionView!.registerClass(XZPhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell_Identifier)
            collectionView?.contentInset = UIEdgeInsets(top: PhotoCollectionCell_YMargin,
                                                        left: PhotoCollectionCell_XMargin,
                                                        bottom: PhotoCollectionCell_YMargin,
                                                        right: PhotoCollectionCell_XMargin)
            collectionView?.alwaysBounceVertical = true
            collectionView?.showsVerticalScrollIndicator = true
            view.addSubview(collectionView!)
        }
    }
}

// MARK: Layout
private extension XZPhotoCollectionController {
    func layoutView() {
        constrain(collectionView!) { (view) in
            view.top == view.superview!.top
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.bottom == view.superview!.bottom
        }
    }
}

// MARK: Style
private extension XZPhotoCollectionController {
    func style() {
        view.backgroundColor = UIColor.whiteColor()
        collectionView!.backgroundColor = UIColor.whiteColor()
    }
}

// MARK: UICollectionViewDataSource
extension XZPhotoCollectionController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionCell_Identifier, forIndexPath: indexPath) as! XZPhotoCollectionCell
        let currentAsset: PHAsset = model.result[indexPath.row] as! PHAsset
        cell.model = XZAssetModel(asset: currentAsset)
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension XZPhotoCollectionController: UICollectionViewDelegate {
    
}














