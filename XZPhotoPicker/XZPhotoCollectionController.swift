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
    private var shouldScrollToBottom: Bool
    
    var model: XZAlbumModel
    
    required init(model: XZAlbumModel) {
        self.model = model
        self.shouldScrollToBottom = true
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshBottomToolBarStatus()
        collectionView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        if shouldScrollToBottom {
            collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: model.count - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: false)
            shouldScrollToBottom = false
        }
    }
}

// MARK: Setup
private extension XZPhotoCollectionController {
    func setup() {
        title = model.name
        
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
                collectionView = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: ScreenWidth, height: ScreenHeight)), collectionViewLayout: collectionViewFlowLayout())
                collectionView!.dataSource = self
                collectionView!.delegate = self
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
        func setupNavigationItem() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(XZAlbumListController.cancelButtonPressed(_:)))
        }
        
        setupCollectionView()
        setupBottomToolBar()
        setupNavigationItem()
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
                previewButton.setTitleColor(PhotoCollection_BottomToolBarPreviewButtonColor_Normal, forState: .Normal)
                previewButton.setTitleColor(PhotoCollection_BottomToolBarPreviewButtonColor_Disabled, forState: .Disabled)
                previewButton.titleLabel?.font = UIFont.systemFontOfSize(PhotoCollection_BottomToolBarFontSize)
                previewButton.addTarget(self, action: #selector(XZPhotoCollectionController.previewButtonPressed(_:)), forControlEvents: .TouchUpInside)
            }
            func styleOKButton() {
                okButton.setTitle("完成", forState: .Normal)
                okButton.setTitle("完成", forState: .Selected)
                okButton.setTitle("完成", forState: .Disabled)
                okButton.setTitleColor(PhotoCollection_BottomToolBarOKButtonColor_Normal, forState: .Normal)
                okButton.setTitleColor(PhotoCollection_BottomToolBarOKButtonColor_Disabled, forState: .Disabled)
                okButton.titleLabel?.font = UIFont.systemFontOfSize(PhotoCollection_BottomToolBarFontSize)
                okButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                okButton.addTarget(self, action: #selector(XZPhotoCollectionController.okButtonPressed(_:)), forControlEvents: .TouchUpInside)
            }
            func styleNumberLabel() {
                numberOfSelectedLabel.text = ""
                numberOfSelectedLabel.textAlignment = .Center
                numberOfSelectedLabel.textColor = UIColor.whiteColor()
                numberOfSelectedLabel.font = UIFont.systemFontOfSize(PhotoCollection_BottomToolBarFontSize)
            }
            func styleNumberCircleView() {
                circleOfNumberImageView.backgroundColor = PhotoCollection_BottomToolBarOKButtonColor_Normal
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

// MARK: BottomToolBarStatus
private extension XZPhotoCollectionController {
    func refreshBottomToolBarStatus() {
        if SelectedAssets.count > 0 {
            previewButton.enabled = true
            okButton.enabled = true
            numberOfSelectedLabel.hidden = false
            circleOfNumberImageView.hidden = false
            
            numberOfSelectedLabel.text = String(SelectedAssets.count)
            
            UIView.oscillatoryAnimationWithLayer(circleOfNumberImageView.layer, max: 1.4, min: 0.7)

        } else {
            previewButton.enabled = false
            okButton.enabled = false
            numberOfSelectedLabel.hidden = true
            circleOfNumberImageView.hidden = true
            
            numberOfSelectedLabel.text = ""
        }
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
        
        currentModel.selected = assetIsSelected(currentAsset)
        cell.model = currentModel

        weak var weakCell = cell
        weak var weakSelf = self
        
        cell.didSelectPhotoClosure = { (selected: Bool, sender: UIButton) -> () in
            weakCell?.model!.selected = selected
            if !selected {
                removeAsset(weakCell!.model!.asset, { (success) in
                    // do nothing here
                })
            } else if selected {
                addAssetModelToSelected(weakCell!.model!, { (fail) in
                    sender.selected = false
                    }, { (success) in
                        // do nothing here
                })
            }
            weakSelf!.refreshBottomToolBarStatus()
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension XZPhotoCollectionController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let previewVC = XZPreviewPhotoController(currentIndex: indexPath.row, models: model.models)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

// MARK: Actions
extension XZPhotoCollectionController {
    func okButtonPressed(sender: UIButton) {
        if sender === okButton {
            weak var presentingVC = self.presentingViewController
            dismissViewControllerAnimated(false, completion: {
                let postVC: XZPostPhotoController = XZPostPhotoController(assets: SelectedAssets)
                let postNav = UINavigationController(rootViewController: postVC)
                presentingVC!.presentViewController(postNav, animated: true, completion: {
                })
            })
        }
    }
    func previewButtonPressed(sender: UIButton) {
        if sender === previewButton {
            if SelectedAssets.count > 0 {
                let firstAsset: XZAssetModel = SelectedAssets[0]
                var currentIndex = -1
                for assetModel in model.models {
                    if XZImageManager.manager.getAssetIdentifier(assetModel.asset) == XZImageManager.manager.getAssetIdentifier(firstAsset.asset) {
                        currentIndex = model.models.indexOf(assetModel)!
                    }
                }
                if currentIndex >= 0 {
                    let previewVC = XZPreviewPhotoController(currentIndex: currentIndex, models: model.models)
                    self.navigationController?.pushViewController(previewVC, animated: true)
                }
            }
        }
    }
    func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {
            emptySelectedAssets()
        }
    }
}














