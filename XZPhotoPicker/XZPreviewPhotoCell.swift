//
//  XZPreviewPhotoCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/22/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZPreviewPhotoCell: UICollectionViewCell {
    private var scrollContainerView: UIScrollView?
    private var photoImageView: UIImageView?
    
    var model: XZAssetModel? {
        didSet {
            if model != nil {
                setupSubviewsIfNeeded()
                weak var weakSelf = self
                XZImageManager.manager.getPhotoWithAsset(self.model!.asset, photoWidth: ScreenWidth) { (img) in
                    weakSelf!.photoImageView!.image = img
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup
private extension XZPreviewPhotoCell {
    func setupSubviewsIfNeeded() {
        func setupScrollContainerView() {
            scrollContainerView = UIScrollView()
            contentView.addSubview(scrollContainerView!)
        }
        func setupPhotoImageView() {
            photoImageView = UIImageView()
            scrollContainerView!.addSubview(photoImageView!)
        }
        
        if scrollContainerView == nil {
            setupScrollContainerView()
            layoutScrollContainerView()
            styleScrollContainerView()
        }
        
        if photoImageView == nil {
            setupPhotoImageView()
            layoutPhotoImageView()
        }
    }
}

// MARK: Layout
private extension XZPreviewPhotoCell {
    func layoutScrollContainerView() {
        constrain(scrollContainerView!) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    func layoutPhotoImageView() {
        constrain(photoImageView!) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
}

// MARK: Style
private extension XZPreviewPhotoCell {
    func styleScrollContainerView() {
        scrollContainerView!.bouncesZoom = true
        scrollContainerView!.maximumZoomScale = PhotoPreview_MaximumZoomScale
        scrollContainerView!.minimumZoomScale = PhotoPreview_MinumumZoomScale
    }
}














