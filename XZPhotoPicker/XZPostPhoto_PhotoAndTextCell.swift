//
//  XZPostPhoto_PhotoAndTextCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/24/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Photos

class XZPostPhoto_PhotoAndTextCell: UITableViewCell {
    private var textView: UITextView?
    private var collectionView: UICollectionView?
    private var placeholderLabel: UILabel?
    
    var assetModels: Array<XZAssetModel>? {
        didSet {
            setupSubviewsIfNeeded()
            collectionView?.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup
private extension XZPostPhoto_PhotoAndTextCell {
    func setupSubviewsIfNeeded() {
        func setupTextView() {
            if textView == nil {
                textView = UITextView()
                contentView.addSubview(textView!)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textViewTextDidChange(_:)), name: UITextViewTextDidChangeNotification, object: nil)
                layoutTextView()
            }
        }
        func setupCollectionView() {
            if collectionView == nil {
                func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
                    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    flowLayout.itemSize = CGSize(width: CGFloat(PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth),
                                                 height: CGFloat(PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth))
                    flowLayout.minimumInteritemSpacing = PostPhoto_CollectionCellMargin
                    flowLayout.minimumLineSpacing = PostPhoto_CollectionCellMargin
                    return flowLayout
                }
                
                if collectionView == nil {
                    
                    let rows: Int = assetModels!.count / 4 + 1
                    let collectionViewHeight = CGFloat(rows) * PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth + (CGFloat(rows) + 1) * PostPhoto_CollectionCellMargin
                    let collectionViewWidth = ScreenWidth - 2 * PostPhoto_TextViewHorizontalMargin
                    let collectionViewXOrigin = PostPhoto_TextViewHorizontalMargin
                    let collectionViewYOrigin = PostPhoto_TextViewHeight + PostPhoto_CollectionViewTopMargin
                    
                    collectionView = UICollectionView(frame: CGRectMake(collectionViewXOrigin, collectionViewYOrigin, collectionViewWidth, collectionViewHeight), collectionViewLayout: collectionViewFlowLayout())
                    collectionView!.dataSource = self
                    collectionView!.delegate = self
                    collectionView!.registerClass(XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell.self, forCellWithReuseIdentifier: PostPhoto_PhotoAndTextCell_PhotoCollectionCell_Identifier)
                    contentView.addSubview(collectionView!)
                }
                layoutCollectionView()
                styleCollectionView()
            }
        }
        func setupPlaceholderLabel() {
            if placeholderLabel == nil {
                placeholderLabel = UILabel()
                contentView.addSubview(placeholderLabel!)
                layoutPlaceholderLabel()
            }
        }
        
        setupTextView()
        setupCollectionView()
        setupPlaceholderLabel()
    }
}

// MARK: Layout
private extension XZPostPhoto_PhotoAndTextCell {
    func layoutTextView() {
        constrain(textView!) { (view) in
            view.top == view.superview!.top
            view.left == view.superview!.left + PostPhoto_TextViewHorizontalMargin
            view.right == view.superview!.right - PostPhoto_TextViewHorizontalMargin
            view.height == PostPhoto_TextViewHeight
        }
    }
    
    func layoutCollectionView() {
        constrain(collectionView!, textView!) { (view1, view2) in
//            view1.left == view2.left
//            view1.right == view2.right
//            view1.top == view2.bottom
//            view1.bottom == view1.superview!.bottom
        }
    }
    
    func layoutPlaceholderLabel() {
        constrain(placeholderLabel!, textView!) { (view1, view2) in
            view1.left == view2.left
            view1.top == view2.top
            view1.right == view2.right
            view1.height == 20
        }
    }
}

// MARK: Style
private extension XZPostPhoto_PhotoAndTextCell {
    func styleTextView() {
        textView?.backgroundColor = UIColor.lightGrayColor()
    }
    func styleCollectionView() {
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.scrollEnabled = false
    }
}

// MARK: NSNotificationCenter handler
extension XZPostPhoto_PhotoAndTextCell {
    func textViewTextDidChange(notification: NSNotification) {
        let textView = notification.object as! UITextView
        placeholderLabel!.hidden = (textView.text as NSString).length <= 0 ? false : true
    }
}

// MARK: UICollectionViewDataSource
extension XZPostPhoto_PhotoAndTextCell: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if assetModels?.count == MaxPhotosCount || assetModels?.count == MaxPhotosCount - 1 {
            return MaxPhotosCount
        }
        return assetModels!.count + 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PostPhoto_PhotoAndTextCell_PhotoCollectionCell_Identifier, forIndexPath: indexPath) as! XZPostPhoto_PhotoAndTextCell_PhotoCollectionCell
        if indexPath.row == assetModels?.count {
            cell.model = nil
            cell.shouldSetCover(false)
        } else {
            cell.model = assetModels![indexPath.row]
            if assetModels?.count > 0 && indexPath.row == 0 {
                cell.shouldSetCover(true)
            } else {
                cell.shouldSetCover(false)
            }
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension XZPostPhoto_PhotoAndTextCell: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // go to preview page
    }
}












