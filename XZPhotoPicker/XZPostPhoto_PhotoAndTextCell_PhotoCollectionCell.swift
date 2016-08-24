//
//  XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/24/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell: UICollectionViewCell {
    private var photoImageView: UIImageView?
    private var coverLabel: UILabel?
    
    var representedAssetIdentifier: String?
    var imageRequestID: PHImageRequestID = 0
    
    var model: XZAssetModel? {
        didSet {
            setupSubviewsIfNeeded()
            if model != nil {
                representedAssetIdentifier = XZImageManager.manager.getAssetIdentifier(self.model!.asset)
                
                weak var weakSelf = self
                let imageRequestID: PHImageRequestID = XZImageManager.manager.getPhotoWithAsset(self.model!.asset, photoWidth: CGFloat(PhotoCollectionCell_PhotoWidth), completion: { (img) in
                    if self.representedAssetIdentifier! == XZImageManager.manager.getAssetIdentifier(self.model!.asset) {
                        weakSelf!.photoImageView?.image = img
                    } else {
//                        print("***---this cell is showing other asset---***")
                        if self.imageRequestID != 0 {
                            PHImageManager.defaultManager().cancelImageRequest(self.imageRequestID)
                        }
                    }
                })
                self.imageRequestID = imageRequestID
            } else {
                photoImageView?.image = UIImage(named: "add.png")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        photoImageView?.image = nil
        coverLabel?.hidden = false
    }
    
    func shouldSetCover(isCover: Bool) {
        if isCover {
            coverLabel?.hidden = false
        } else {
            coverLabel?.hidden = true
        }
    }
}

// MARK: Setup
private extension XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell {
    func setupSubviewsIfNeeded() {
        func setupPhotoImageView() {
            photoImageView = UIImageView()
            contentView.addSubview(photoImageView!)
        }
        func setupCoverLabel() {
            coverLabel = UILabel()
            contentView.addSubview(coverLabel!)
        }
        
        if photoImageView == nil {
            setupPhotoImageView()
            layoutPhotoImageView()
            stylePhotoImageView()
        }
        if coverLabel == nil {
            setupCoverLabel()
            layoutCoverLabel()
            styleCoverLabel()
        }
    }
}

// MARK: Layout
private extension XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell {
    func layoutPhotoImageView() {
        constrain(photoImageView!) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    
    func layoutCoverLabel() {
        constrain(coverLabel!) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.bottom == view.superview!.bottom
            view.height == view.superview!.height / 3
        }
    }
}

// MARK: Style
private extension XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell {
    func stylePhotoImageView() {
        photoImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        photoImageView!.clipsToBounds = true
    }
    func styleCoverLabel() {
        coverLabel?.backgroundColor = PostPhoto_CoverPhotoLabelBgColor
        coverLabel?.text = "主图"
        coverLabel?.font = UIFont.systemFontOfSize(floor(self.frame.size.height / 3 * 0.6))
        coverLabel?.textColor = UIColor.whiteColor()
        coverLabel?.textAlignment = .Center
        coverLabel?.numberOfLines = 1
    }
}




