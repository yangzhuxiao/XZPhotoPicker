//
//  XZPostPhotoFirstCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/27/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Photos

class XZPostPhotoFirstCell: UITableViewCell {
    private var textView: UITextView?
    private var collectionView: UICollectionView?
    private var placeholderLabel: UILabel?
    
    var goToPostPreviewBlock = {(currentIndex: Int) -> () in }
    var addButtonPressedBlock = {() -> () in }
    
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
    
    func textViewShouldResignFirstResponder() {
        textView!.resignFirstResponder()
    }
}

// MARK: Setup
private extension XZPostPhotoFirstCell {
    func setupSubviewsIfNeeded() {
        func setupTextView() {
            if textView == nil {
                let textViewXOrigin = PostPhoto_TextViewHorizontalMargin
                let textViewYOrigin: CGFloat = 0
                let textViewWidth = ScreenWidth - 2 * PostPhoto_TextViewHorizontalMargin
                
                textView = UITextView(frame: CGRectMake(textViewXOrigin, textViewYOrigin, textViewWidth, PostPhotoFirstCell_TextViewHeight))
                contentView.addSubview(textView!)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textViewTextDidChange(_:)), name: UITextViewTextDidChangeNotification, object: nil)
                styleTextView()
            }
        }
        func setupCollectionView() {
            func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
                let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                flowLayout.itemSize = CGSize(width: CGFloat(PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth),
                                             height: CGFloat(PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth))
                flowLayout.minimumInteritemSpacing = PostPhoto_CollectionCellMargin
                flowLayout.minimumLineSpacing = PostPhoto_CollectionCellMargin
                return flowLayout
            }
            
            if collectionView == nil {
                collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout())
                collectionView!.dataSource = self
                collectionView!.delegate = self
                collectionView!.registerClass(XZPostPhotoFirstCell_PhotoCollectionCell.self, forCellWithReuseIdentifier: PostPhotoFirstCell_PhotoCollectionCell_Identifier)
                contentView.addSubview(collectionView!)
            }
            styleCollectionView()
        }
        
        func setupPlaceholderLabel() {
            if placeholderLabel == nil {
                placeholderLabel = UILabel()
                contentView.addSubview(placeholderLabel!)
                layoutPlaceholderLabel()
                stylePlaceholderLabel()
            }
        }
        
        setupTextView()
        setupCollectionView()
        setupPlaceholderLabel()
    }
}

// MARK: Layout
private extension XZPostPhotoFirstCell {
    func layoutPlaceholderLabel() {
        constrain(placeholderLabel!, textView!) { (view1, view2) in
            view1.left == view2.left + 5
            view1.top == view2.top + 6
            view1.right == view2.right
            view1.height == 20
        }
    }
}

// MARK: Style
private extension XZPostPhotoFirstCell {
    func styleTextView() {
        textView?.font = UIFont.systemFontOfSize(14)
    }
    func styleCollectionView() {
        let rows: Int = assetModels!.count / 4 + 1
        let collectionViewHeight = CGFloat(rows) * PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth + (CGFloat(rows) + 1) * PostPhoto_CollectionCellMargin
        let collectionViewWidth = ScreenWidth - 2 * PostPhoto_TextViewHorizontalMargin
        let collectionViewXOrigin = PostPhoto_TextViewHorizontalMargin
        let collectionViewYOrigin = PostPhotoFirstCell_TextViewHeight + PostPhotoFirstCell_CollectionViewTopMargin
        
        collectionView!.frame = CGRectMake(collectionViewXOrigin, collectionViewYOrigin, collectionViewWidth, collectionViewHeight)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.scrollEnabled = false
    }
    func stylePlaceholderLabel() {
        placeholderLabel?.text = "想说点什么"
        placeholderLabel?.textColor = UIColor.lightGrayColor()
        placeholderLabel?.font = UIFont.systemFontOfSize(14)
    }
}

// MARK: NSNotificationCenter handler
extension XZPostPhotoFirstCell {
    func textViewTextDidChange(notification: NSNotification) {
        let textView = notification.object as! UITextView
        placeholderLabel!.hidden = (textView.text as NSString).length <= 0 ? false : true
    }
}

// MARK: UICollectionViewDataSource
extension XZPostPhotoFirstCell: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PostPhotoFirstCell_PhotoCollectionCell_Identifier, forIndexPath: indexPath) as! XZPostPhotoFirstCell_PhotoCollectionCell
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
extension XZPostPhotoFirstCell: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // go to preview page
        if SelectedAssets.count < 9 && indexPath.row == SelectedAssets.count {
            // clicked "+" button
            addButtonPressedBlock()
        } else {
            goToPostPreviewBlock(indexPath.row)
        }
    }
}





