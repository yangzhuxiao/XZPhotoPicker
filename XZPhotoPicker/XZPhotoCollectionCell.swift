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

class XZPhotoCollectionCell: UICollectionViewCell {
    private let photoImageView = UIImageView()
    private let checkmarkImageView = UIImageView()
    private let checkmarkButton = UIButton()
    var model: XZAssetModel? {
        didSet {
            if model != nil {
                XZImageManager.manager.getPhotoWithAsset(self.model!.asset, photoWidth: CGFloat(PhotoCollectionCell_PhotoWidth), completion: { (img) in
                    weak var weakSelf = self
                    weakSelf!.photoImageView.image = img
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        layoutView()
        style()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        checkmarkButton.selected = false
        setupCheckmarkImage()
    }
}

// MARK: Setup
private extension XZPhotoCollectionCell {
    func setup() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(checkmarkButton)
        
        setupCheckmarkButton()
        setupCheckmarkImage()
    }
    func setupCheckmarkButton() {
        checkmarkButton.addTarget(self, action: #selector(XZPhotoCollectionCell.checkmarkButtonClicked(_:)), forControlEvents: .TouchUpInside)
    }
    func setupCheckmarkImage() {
        checkmarkImageView.image = checkmarkButton.selected ? UIImage(named: "photoCollectionCell_checkmark_checked") : UIImage(named: "photoCollectionCell_checkmark_uncheck")
    }
}

// MARK: Layout
private extension XZPhotoCollectionCell {
    func layoutView() {
        constrain(photoImageView) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
        constrain(checkmarkButton) { (view) in
            view.top == view.superview!.top
            view.right == view.superview!.right
            view.width == view.superview!.width * PhotoCollectionCell_ClickableAreaRatio
            view.height == view.superview!.height * PhotoCollectionCell_ClickableAreaRatio
        }
        constrain(checkmarkImageView) { (view) in
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
        photoImageView.contentMode = UIViewContentMode.ScaleAspectFill
        photoImageView.clipsToBounds = true
        
        checkmarkButton.backgroundColor = UIColor.clearColor()
    }
}

// MARK: Actions
extension XZPhotoCollectionCell {
    func checkmarkButtonClicked(sender: UIButton) {
        if sender === checkmarkButton {
            sender.selected = !sender.selected
            setupCheckmarkImage()
        }
    }
}














