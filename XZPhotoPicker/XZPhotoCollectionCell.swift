//
//  XZPhotoCollectionCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/21/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Photos

class XZPhotoCollectionCell: UICollectionViewCell {
    private var photoImageView: UIImageView?
    private var checkmarkImageView: UIImageView?
    private var checkmarkButton: UIButton?
    
    var representedAssetIdentifier: String?
    var imageRequestID: PHImageRequestID = 0
    
    var model: XZAssetModel? {
        didSet {
            if model != nil {
                setupSubviews()
                representedAssetIdentifier = XZImageManager.manager.getAssetIdentifier(self.model!.asset)
                let imageRequestID: PHImageRequestID = XZImageManager.manager.getPhotoWithAsset(self.model!.asset, photoWidth: CGFloat(PhotoCollectionCell_PhotoWidth), completion: { (img) in
                    
                    if self.representedAssetIdentifier! == XZImageManager.manager.getAssetIdentifier(self.model!.asset) {
                        weak var weakSelf = self
                        weakSelf!.photoImageView?.image = img
                    } else {
                        print("*******-------this cell is showing other asset-------*******")
                        if self.imageRequestID != 0 {
                            PHImageManager.defaultManager().cancelImageRequest(self.imageRequestID)
                        }
                    }
                })
                
//                if imageRequestID != 0 && self.imageRequestID != 0 && imageRequestID != self.imageRequestID {
//                    PHImageManager.defaultManager().cancelImageRequest(self.imageRequestID)
//                }
                
                self.imageRequestID = imageRequestID
                self.checkmarkButton?.selected = model!.selected
                setupCheckmarkStatus()
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
private extension XZPhotoCollectionCell {
    func setupSubviews() {
        func setupPhotoImageView() {
            photoImageView = UIImageView()
            contentView.addSubview(photoImageView!)
        }
        func setupCheckmarkImageView() {
            checkmarkImageView = UIImageView()
            contentView.addSubview(checkmarkImageView!)
            setupCheckmarkStatus()
        }
        func setupCheckmarkButton() {
            checkmarkButton = UIButton()
            checkmarkButton!.addTarget(self, action: #selector(XZPhotoCollectionCell.checkmarkButtonClicked(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(checkmarkButton!)
        }
        
        if photoImageView == nil {
            setupPhotoImageView()
            layoutPhotoImageView()
        }
        if checkmarkImageView == nil {
            setupCheckmarkImageView()
            layoutCheckmarkImageView()
            stylePhotoImageView()
        }
        if checkmarkButton == nil {
            setupCheckmarkButton()
            layoutCheckmarkButton()
        }
    }
    
    func setupCheckmarkStatus() {
        if checkmarkImageView != nil && checkmarkButton != nil {
            checkmarkImageView!.image = checkmarkButton!.selected ? UIImage(named: "photoCollectionCell_checkmark_checked") : UIImage(named: "photoCollectionCell_checkmark_uncheck")
        }
    }
}

// MARK: Layout
private extension XZPhotoCollectionCell {
    func layoutPhotoImageView() {
        constrain(photoImageView!) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    func layoutCheckmarkButton() {
        constrain(checkmarkButton!) { (view) in
            view.top == view.superview!.top
            view.right == view.superview!.right
            view.width == view.superview!.width * PhotoCollectionCell_ClickableAreaRatio
            view.height == view.superview!.height * PhotoCollectionCell_ClickableAreaRatio
        }
    }
    
    func layoutCheckmarkImageView() {
        constrain(checkmarkImageView!) { (view) in
            view.width == PhotoCollectionCell_CheckMarkImageSize.width
            view.height == PhotoCollectionCell_CheckMarkImageSize.height
            view.top == view.superview!.top + PhotoCollectionCell_CheckMarkImageMargin
            view.right == view.superview!.right - PhotoCollectionCell_CheckMarkImageMargin
        }
    }
}

// MARK: Style
private extension XZPhotoCollectionCell {
    
    func stylePhotoImageView() {
        photoImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        photoImageView!.clipsToBounds = true
    }
}

// MARK: Actions
extension XZPhotoCollectionCell {
    func checkmarkButtonClicked(sender: UIButton) {
        if sender === checkmarkButton {
            sender.selected = !sender.selected
//            model?.selected = sender.selected
            setupCheckmarkStatus()
        }
    }
}














