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
    private let previewButton = UIButton()
    private let okButton = UIButton()
    private let numberOfSelectedLabel = UILabel()
    private let circleOfNumberImageView = UIView()
    private let toolBarView = UIView()
    
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
        setupBottomToolBar()
    }
    
    func setupCollectionView() {
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
            view.addSubview(collectionView!)
        }
    }
    
    func setupBottomToolBar() {
        view.addSubview(toolBarView)
        
        toolBarView.addSubview(previewButton)
        toolBarView.addSubview(circleOfNumberImageView)
        toolBarView.addSubview(numberOfSelectedLabel)
        toolBarView.addSubview(okButton)
    }
}

// MARK: Layout
private extension XZPhotoCollectionController {
    func layoutView() {
        constrain(toolBarView) { (view) in
            view.left == view.superview!.left - 1
            view.right == view.superview!.right + 1
            view.bottom == view.superview!.bottom + 1
            view.height == PhotoCollection_BottomToolBarHeight
        }
        constrain(collectionView!, toolBarView) { (view1, view2) in
            view1.top == view1.superview!.top
            view1.left == view1.superview!.left
            view1.right == view1.superview!.right
            view1.bottom == view2.top
        }
        constrain(previewButton) { (view) in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.width == view.height * 1.5
        }
        constrain(okButton, numberOfSelectedLabel, circleOfNumberImageView) { (view1, view2, view3) in
            view1.right == view1.superview!.right
            view1.top == view1.superview!.top
            view1.bottom == view1.superview!.bottom
            view1.width == view1.height * 1.5
            
            view2.centerY == view2.superview!.centerY
            view2.width == PhotoCollection_BottomToolBarNumberOfSelectedLabelHeight
            view2.height == view2.width
            view2.left == view1.left
            
            view3.top == view2.top
            view3.bottom == view2.bottom
            view3.left == view2.left
            view3.right == view2.right
        }
    }
}

// MARK: Style
private extension XZPhotoCollectionController {
    func style() {
        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        
        func styleCollectionView() {
            collectionView?.backgroundColor = UIColor.whiteColor()
            collectionView?.contentInset = UIEdgeInsets(top: PhotoCollectionCell_YMargin,
                                                        left: PhotoCollectionCell_XMargin,
                                                        bottom: PhotoCollectionCell_YMargin,
                                                        right: PhotoCollectionCell_XMargin)
            collectionView?.alwaysBounceVertical = true
            collectionView?.showsVerticalScrollIndicator = true
        }
        
        func styleToolBarView() {
            func styleToolBarContainerView() {
                toolBarView.backgroundColor = PhotoCollection_BottomToolBarBgColor
                toolBarView.layer.borderColor = PhotoCollection_BottomToolBarSeparatorColor.CGColor
                toolBarView.layer.borderWidth = 0.5
            }
            func stylePreviewButton() {
                previewButton.setTitle("预览", forState: .Normal)
                previewButton.setTitle("预览", forState: .Disabled)
                previewButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                previewButton.titleLabel?.font = UIFont.systemFontOfSize(PhotoCollection_BottomToolBarFontSize)
            }
            func styleOKButton() {
                okButton.setTitle("完成", forState: .Normal)
                okButton.setTitle("完成", forState: .Selected)
                okButton.setTitle("完成", forState: .Disabled)
                okButton.setTitleColor(PhotoCollection_BottomToolBarOKButtonColor, forState: .Normal)
                okButton.titleLabel?.font = UIFont.systemFontOfSize(PhotoCollection_BottomToolBarFontSize)
                okButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            }
            func styleNumberLabel() {
                numberOfSelectedLabel.text = "3"
                numberOfSelectedLabel.textAlignment = .Center
                numberOfSelectedLabel.textColor = UIColor.whiteColor()
                numberOfSelectedLabel.font = UIFont.systemFontOfSize(PhotoCollection_BottomToolBarFontSize)
            }
            func styleNumberCircleView() {
                circleOfNumberImageView.backgroundColor = PhotoCollection_BottomToolBarOKButtonColor
                circleOfNumberImageView.clipsToBounds = true
                circleOfNumberImageView.layer.cornerRadius = PhotoCollection_BottomToolBarNumberOfSelectedLabelHeight/2
            }
            
            styleOKButton()
            styleNumberLabel()
            stylePreviewButton()
            styleNumberCircleView()
            styleToolBarContainerView()
        }
        
        styleToolBarView()
        styleCollectionView()
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
        let currentModel = XZAssetModel(asset: currentAsset)
        for model in SelectedAssets {
            if XZImageManager.manager.getAssetIdentifier(model.asset) == XZImageManager.manager.getAssetIdentifier(currentModel.asset) {
                currentModel.selected = true
            }
        }
        cell.model = currentModel

        weak var weakCell = cell
        cell.didSelectPhotoClosure = { (selected: Bool) -> () in
//            print("model is selected: \(selected)")
            weakCell?.model!.selected = selected
//            print("weakCell.model is selected: \(weakCell.model!.selected)")
            if !selected {
                for model in SelectedAssets {
                    if XZImageManager.manager.getAssetIdentifier(model.asset) == XZImageManager.manager.getAssetIdentifier(weakCell!.model!.asset) {
                        let indexOfObject = SelectedAssets.indexOf(model)
//                        print("*****model is selected: \(model.selected)")
                        SelectedAssets.removeAtIndex(indexOfObject!)
                    }
                }
            } else if selected {
                SelectedAssets.append(weakCell!.model!)
            }
//            print("count of selectedAssets: \(selectedAssets.count)")
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension XZPhotoCollectionController: UICollectionViewDelegate {
    
}














