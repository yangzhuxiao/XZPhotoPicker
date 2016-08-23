//
//  XZPreviewPhotoController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/22/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZPreviewPhotoController: UIViewController {
    var models: Array<XZAssetModel>
    var photos: Array<PHAsset> = []
    var currentIndex: Int = 0
    
    private var collectionView: UICollectionView?
    
    private let navBarView = UIView()
    private let backButton = UIButton()
    private let checkmarkButton = UIButton()
    
    private let toolBarView = UIView()
    private let okButton = UIButton()
    private let numberOfSelectedLabel = UILabel()
    private let circleOfNumberImageView = UIView()
    
    required init(currentIndex: Int, models: Array<XZAssetModel>) {
        self.models = models
        self.currentIndex = currentIndex
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
        self.navigationController?.navigationBarHidden = true
        collectionView?.setContentOffset(CGPointMake(ScreenWidth * CGFloat(currentIndex), 0), animated: false)
        refreshNavAndToolBarDataStatus()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

// MARK: Setup
private extension XZPreviewPhotoController {
    func setup() {
        func setupCollectinView() {
            func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
                flowLayout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                return flowLayout
            }
            if collectionView == nil {
                collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout())
                collectionView?.registerClass(XZPreviewPhotoCell.self, forCellWithReuseIdentifier: PhotoPreviewCell_Identifier)
                collectionView?.contentSize = CGSize(width: CGFloat(models.count) * ScreenWidth, height: 0)
                collectionView?.dataSource = self
                collectionView?.delegate = self
                view.addSubview(collectionView!)
            }
        }
        
        func setupNavBarView() {
            view.addSubview(navBarView)
            navBarView.addSubview(backButton)
            navBarView.addSubview(checkmarkButton)
            
            backButton.addTarget(self, action: #selector(XZPreviewPhotoController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
            checkmarkButton.addTarget(self, action: #selector(XZPreviewPhotoController.checkmarkButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
        
        func setupToolBarView() {
            view.addSubview(toolBarView)
            toolBarView.addSubview(okButton)
            toolBarView.addSubview(circleOfNumberImageView)
            toolBarView.addSubview(numberOfSelectedLabel)
            
            okButton.addTarget(self, action: #selector(XZPreviewPhotoController.okButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
        
        setupCollectinView()
        setupToolBarView()
        setupNavBarView()
    }
    
}

// MARK: Layout
private extension XZPreviewPhotoController {
    func layoutView() {
        constrain(collectionView!) { (view1) in
            view1.top == view1.superview!.top
            view1.left == view1.superview!.left
            view1.right == view1.superview!.right
            view1.bottom == view1.superview!.bottom
        }
        constrain(toolBarView) { (view) in
            view.left == view.superview!.left
            view.right == view.superview!.right + 1
            view.bottom == view.superview!.bottom
            view.height == PhotoPreview_BottomToolBarHeight
        }
        constrain(okButton, numberOfSelectedLabel, circleOfNumberImageView) { (view1, view2, view3) in
            view1.right == view1.superview!.right
            view1.top == view1.superview!.top
            view1.bottom == view1.superview!.bottom
            view1.width == view1.height * 1.5
            
            view2.centerY == view2.superview!.centerY
            view2.width == PhotoPreview_BottomToolBarNumberOfSelectedLabelHeight
            view2.height == view2.width
            view2.left == view1.left
            
            view3.top == view2.top
            view3.bottom == view2.bottom
            view3.left == view2.left
            view3.right == view2.right
        }
        constrain(navBarView) { (view) in
            view.top == view.superview!.top
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.height == PhotoPreview_NavBarHeight
        }
        constrain(backButton, checkmarkButton) { (view1, view2) in
            view1.top == view1.superview!.top
            view1.left == view1.superview!.left
            view1.bottom == view1.superview!.bottom
            view1.width == view1.height
            
            view2.top == view2.superview!.top
            view2.right == view2.superview!.right
            view2.bottom == view2.superview!.bottom
            view2.width == view2.height
        }
    }
}

// MARK: Style
private extension XZPreviewPhotoController {
    func style() {
        func styleCollectionView() {
            collectionView?.pagingEnabled = true
        }
        func styleToolBarView() {
            func styleToolBarContainerView() {
                toolBarView.backgroundColor = PhotoPreview_BottomToolBarBgColor
            }
            func styleOKButton() {
                okButton.setTitle("完成", forState: .Normal)
                okButton.setTitleColor(PhotoPreview_BottomToolBarOKButtonColor_Normal, forState: .Normal)
                okButton.titleLabel?.font = UIFont.systemFontOfSize(PhotoPreview_BottomToolBarFontSize)
                okButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            }
            func styleNumberLabel() {
                numberOfSelectedLabel.text = ""
                numberOfSelectedLabel.textAlignment = .Center
                numberOfSelectedLabel.textColor = UIColor.whiteColor()
                numberOfSelectedLabel.font = UIFont.systemFontOfSize(PhotoPreview_BottomToolBarFontSize)
            }
            func styleNumberCircleView() {
                circleOfNumberImageView.backgroundColor = PhotoPreview_BottomToolBarOKButtonColor_Normal
                circleOfNumberImageView.clipsToBounds = true
                circleOfNumberImageView.layer.cornerRadius = PhotoPreview_BottomToolBarNumberOfSelectedLabelHeight/2
            }
            
            styleOKButton()
            styleNumberLabel()
            styleNumberCircleView()
            styleToolBarContainerView()
        }
        func styleNavBarView() {
            func styleNavBarContainerView() {
                navBarView.backgroundColor = PhotoPreview_NavBarBgColor
            }
            func styleBackButton() {
                backButton.setImage(UIImage(named: "navi_back"), forState: .Normal)
            }
            func styleCheckmarkButton() {
                checkmarkButton.setImage(UIImage(named: "photoPreview_checkmark_uncheck"), forState: .Normal)
                checkmarkButton.setImage(UIImage(named: "photoPreview_checkmark_checked"), forState: .Selected)
            }
            styleNavBarContainerView()
            styleBackButton()
            styleCheckmarkButton()
        }
        
        styleToolBarView()
        styleCollectionView()
        styleNavBarView()
    }
    
    func toggleNavAndToolBarDisplayStatus() {
        if navBarView.hidden == true && toolBarView.hidden == true {
            navBarView.hidden = false
            toolBarView.hidden = false
        } else {
            navBarView.hidden = true
            toolBarView.hidden = true
        }
    }

    func refreshNavAndToolBarDataStatus() {
        let currentModel: XZAssetModel = models[currentIndex]
        
        currentModel.selected = assetIsSelected(currentModel.asset)
        checkmarkButton.selected = currentModel.selected
        
        circleOfNumberImageView.hidden = SelectedAssets.count <= 0 ? true : false
        if circleOfNumberImageView.hidden == false {
            numberOfSelectedLabel.text = String(SelectedAssets.count)
            numberOfSelectedLabel.hidden = false
        } else {
            numberOfSelectedLabel.hidden = true
        }
    }
}

// MARK: Actions
extension XZPreviewPhotoController {
    func backButtonPressed(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    func checkmarkButtonPressed(sender: UIButton) {
        checkmarkButton.selected = !checkmarkButton.selected
        
        let currentModel: XZAssetModel = models[currentIndex]
        currentModel.selected = checkmarkButton.selected
        
        weak var weakSelf = self
        if currentModel.selected {
            addAssetModelToSelected(currentModel, { (fail) in
                weakSelf!.checkmarkButton.selected = false
                currentModel.selected = false
                }, { (success) in
                    weakSelf!.refreshNavAndToolBarDataStatus()
            })
        } else {
            removeAsset(currentModel.asset, { (success) in
                weakSelf!.refreshNavAndToolBarDataStatus()
            })
        }
    }
    func okButtonPressed(sender: UIButton) {
        
    }
}

// MARK: UICollectionViewDataSource
extension XZPreviewPhotoController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoPreviewCell_Identifier, forIndexPath: indexPath) as! XZPreviewPhotoCell
        cell.model = models[indexPath.row]
        
        weak var weakSelf = self
        cell.singleTapGestureBlock = {() -> () in
            // TBD... show/hide toolbar and navBar
            weakSelf!.toggleNavAndToolBarDisplayStatus()
        }
        return cell
    }
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        (cell as! XZPreviewPhotoCell).recoverSubviews()
//    }
//    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        (cell as! XZPreviewPhotoCell).recoverSubviews()
//    }
}

// MARK: UIScrollViewDelegate
extension XZPreviewPhotoController: UICollectionViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let theIndex = Int(offsetX / ScreenWidth)
        
        if theIndex != currentIndex {
            currentIndex = theIndex
            refreshNavAndToolBarDataStatus()
        }
    }
}



















