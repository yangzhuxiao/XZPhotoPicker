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
                representedAssetIdentifier = XZImageManager.manager.getAssetIdentifier(self.model!.asset)
                
                setup()
//                layoutView()
//                style()
                
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
                
                print("self.imageRequestID: ", self.imageRequestID, "----imageRequestID: ", imageRequestID)
                print("outer...")
                if imageRequestID != 0 && self.imageRequestID != 0 && imageRequestID != self.imageRequestID {
                    print("before cancelImageRequest...")
                    PHImageManager.defaultManager().cancelImageRequest(self.imageRequestID)
                    print("after cancelImageRequest...")
                }
                
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setup()
//        layoutView()
//        style()
//    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        photoImageView.image = nil
//        checkmarkButton.selected = false
//        setupCheckmarkImage()
//    }
}

// MARK: Setup
private extension XZPhotoCollectionCell {
    func setup() {
        if photoImageView == nil {
            setupPhotoImageView()
            layoutPhotoImageView()
        }
        
        if checkmarkImageView == nil {
            setupCheckmarkImageView()
            layoutCheckmarkImageView()
        }
        
        if checkmarkButton == nil {
            setupCheckmarkButton()
            layoutCheckmarkButton()
            style()
        }
    }
    
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
    
    func setupCheckmarkStatus() {
        if checkmarkImageView != nil && checkmarkButton != nil {
            checkmarkImageView!.image = checkmarkButton!.selected ? UIImage(named: "photoCollectionCell_checkmark_checked") : UIImage(named: "photoCollectionCell_checkmark_uncheck")
        }
    }
}

// MARK: Layout
private extension XZPhotoCollectionCell {
//    func layoutView() {
//        
//        
//        
//    }
    
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
    func style() {
        contentView.backgroundColor = UIColor.whiteColor()
        photoImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        photoImageView!.clipsToBounds = true
        
        checkmarkButton!.backgroundColor = UIColor.clearColor()
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














