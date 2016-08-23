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
    var singleTapGestureBlock = {() -> () in
    }
    
    var model: XZAssetModel? {
        didSet {
            if model != nil {
                setupSubviewsIfNeeded()
                scrollContainerView?.setZoomScale(1.0, animated: false)
                weak var weakSelf = self
                XZImageManager.manager.getPhotoWithAsset(self.model!.asset) { (img) in
                    weakSelf!.photoImageView!.image = img
                    weakSelf!.resizeSubviews()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let singleTapping = UITapGestureRecognizer(target: self, action: #selector(XZPreviewPhotoCell.singleTap(_:)))
        self.addGestureRecognizer(singleTapping)
        
        let doubleTapping = UITapGestureRecognizer(target: self, action: #selector(XZPreviewPhotoCell.doubleTap(_:)))
        doubleTapping.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapping)
        
//        singleTapping.requireGestureRecognizerToFail(doubleTapping)
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
            scrollContainerView?.delegate = self
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
//            layoutPhotoImageView()
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
//    func layoutPhotoImageView() {
//        constrain(photoImageView!) { (view) in
//            view.left == view.superview!.left
//            view.right == view.superview!.right
//            view.top == view.superview!.top
//            view.bottom == view.superview!.bottom
//        }
//    }
}

// MARK: Style
private extension XZPreviewPhotoCell {
    func styleScrollContainerView() {
        scrollContainerView!.bouncesZoom = true
        scrollContainerView!.maximumZoomScale = PhotoPreview_MaximumZoomScale
        scrollContainerView!.minimumZoomScale = PhotoPreview_MinumumZoomScale
        
        scrollContainerView?.showsVerticalScrollIndicator = false
        scrollContainerView?.showsHorizontalScrollIndicator = true
    }
}

// MARK: Resize subviews
extension XZPreviewPhotoCell {
    func recoverSubviews() {
        scrollContainerView?.setZoomScale(1.0, animated: false)
        resizeSubviews()
    }
    
    private func resizeSubviews() {
        photoImageView?.frame.origin = CGPointZero
        
        let photo = photoImageView!.image!
        var imgNewHeight: CGFloat?
        var imgCenterY: CGFloat = 0
        // aspect ratio was too high
        if photo.size.height/photo.size.width > ScreenHeight / ScreenWidth {
            imgNewHeight = floor(photo.size.height / (photo.size.width / ScreenWidth))
        } else {
            imgNewHeight = floor(photo.size.height / photo.size.width * ScreenWidth)
//            if imgNewHeight!.isNaN || imgNewHeight < scrollContainerView!.frame.size.height {
//                imgNewHeight = ScreenHeight
//            }
            imgCenterY = ScreenHeight / 2
        }
        
        photoImageView?.frame = CGRect(origin: CGPointZero, size: CGSize(width: scrollContainerView!.frame.width, height: imgNewHeight!))
        if imgCenterY != 0 {
            photoImageView?.center.y = imgCenterY
        }
            
        scrollContainerView?.contentSize = CGSize(width: ScreenWidth, height: max(ScreenHeight, imgNewHeight!))
        scrollContainerView?.scrollRectToVisible(scrollContainerView!.bounds, animated: false)
        scrollContainerView?.alwaysBounceVertical = imgNewHeight! <= ScreenHeight ? false : true
    }
}

// MARK: UIScrollViewDelegate
extension XZPreviewPhotoCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let offsetX: CGFloat = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY: CGFloat = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0
        photoImageView?.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY)
    }
}

// MARK: UITapGestureRecognizer Event
extension XZPreviewPhotoCell {
    func singleTap(tap: UITapGestureRecognizer) {
        singleTapGestureBlock()
    }
    func doubleTap(tap: UITapGestureRecognizer) {
        if scrollContainerView?.zoomScale > 1.0 {
            scrollContainerView?.setZoomScale(1.0, animated: true)
        } else {
            let touchPoint = tap.locationInView(photoImageView)
            let newZoomScale = PhotoPreview_MaximumZoomScale
            let xSize = ScreenWidth / newZoomScale
            let ySize = ScreenHeight / newZoomScale
            scrollContainerView?.zoomToRect(CGRect(x: touchPoint.x - xSize/2, y: touchPoint.y - ySize/2, width: xSize, height: ySize), animated: true)
        }
    }
}













