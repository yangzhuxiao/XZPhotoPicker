//
//  Constants.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/20/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos

// MARK: Global
var ImageScaleFactor: CGFloat = 0
let MaxPhotosCount: Int = 9

var LightContentStatusBar = {() -> () in
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
}
var DarkContentStatusBar = {() -> () in
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
}
var HideStatusbar = {() -> () in
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
}
var ShowStatusbar = {() -> () in
    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
}
var StatusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height

// MARK: Selected Assets
var SelectedAssets: Array<XZAssetModel> = []
var AddAssetModelToSelected = {(model: XZAssetModel, fail: (fail: Bool) -> Void, success: (success: Bool) -> Void) -> () in
    if SelectedAssets.count >= MaxPhotosCount {
        let alert = UIAlertView(title: nil, message: "最多可以选\(MaxPhotosCount)张", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        fail(fail: true)
    } else {
        SelectedAssets.append(model)
        success(success: true)
    }
}
var AssetIsSelected = {(asset: PHAsset) -> (Bool) in
    for model in SelectedAssets {
        if XZImageManager.manager.getAssetIdentifier(model.asset) == XZImageManager.manager.getAssetIdentifier(asset) {
            return true
        }
    }
    return false
}
var RemoveAsset = {(asset: PHAsset, completion: (success: Bool) -> ()) -> () in
    var success: Bool = false
    for model in SelectedAssets {
        if XZImageManager.manager.getAssetIdentifier(model.asset) == XZImageManager.manager.getAssetIdentifier(asset) {
            let indexOfObject = SelectedAssets.indexOf(model)
//            print("*****model is selected: \(model.selected)")
            if indexOfObject >= 0 && indexOfObject <= SelectedAssets.count - 1 {
                model.selected = false
                SelectedAssets.removeAtIndex(indexOfObject!)
                success = true
                completion(success: success)
            }
        }
    }
    if !success {
        let alert = UIAlertView(title: nil, message: "remove selected asset failed...", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
var EmptySelectedAssets = {() -> () in
    SelectedAssets.removeAll()
}

// MARK:
let ScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let ScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height

func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha/1.0)
}

let NavBgColor = RGBA(65, green: 65, blue: 65, alpha: 1)

// MARK: Album List View
let AlbumListRowHeight: CGFloat = 60
let AlbumListTitleFontSize: CGFloat = 17
let AlbumListCell_Identifier: String = "AlbumListCell_Identifier"

// MARK: Photo Collection View
let PhotoCollectionCell_NumOfPhotosInARow: Int = 4
let PhotoCollectionCell_ClickableAreaRatio: CGFloat = 0.45
let PhotoCollectionCell_CheckMarkImageSize: CGSize = CGSize(width: 27, height: 27) // 选择对号大小
let PhotoCollectionCell_CheckMarkImageMargin: CGFloat = 2 // 选择对号上、右边距

let PhotoCollectionCell_XMargin: CGFloat = 2 // collectionViewCell左右侧间距
let PhotoCollectionCell_YMargin = PhotoCollectionCell_XMargin // collectionViewCell上下侧间距
let PhotoCollectionCell_PhotoWidth: Double = (Double(ScreenWidth) - (Double(PhotoCollectionCell_NumOfPhotosInARow - 1) + 2) * Double(PhotoCollectionCell_XMargin)) / 4
let PhotoCollectionCell_Identifier: String = "PhotoCollectionCell_Identifier"

let PhotoCollection_BottomToolBarBgColor = RGBA(250, green: 250, blue: 250, alpha: 1)
let PhotoCollection_BottomToolBarSeparatorColor = RGBA(180, green: 180, blue: 180, alpha: 1)
let PhotoCollection_BottomToolBarHeight: CGFloat = 49

let PhotoCollection_BottomToolBarOKButtonColor_Normal = RGBA(0, green: 220, blue: 0, alpha: 1)
let PhotoCollection_BottomToolBarOKButtonColor_Disabled = RGBA(0, green: 220, blue: 0, alpha: 0.3)

let PhotoCollection_BottomToolBarPreviewButtonColor_Normal = RGBA(0, green: 0, blue: 0, alpha: 1)
let PhotoCollection_BottomToolBarPreviewButtonColor_Disabled = RGBA(0, green: 0, blue: 0, alpha: 0.3)

let PhotoCollection_BottomToolBarNumberOfSelectedLabelHeight: CGFloat = 20
let PhotoCollection_BottomToolBarFontSize: CGFloat = 16

// MARK: Photo Preview View
let PhotoPreview_MaximumZoomScale: CGFloat = 2.0
let PhotoPreview_MinumumZoomScale: CGFloat = 1.0

let PhotoPreviewCell_Identifier: String = "PhotoPreviewCell_Identifier"

let PhotoPreview_BottomToolBarBgColor = RGBA(100, green: 100, blue: 100, alpha: 0.6)
let PhotoPreview_BottomToolBarHeight: CGFloat = 49

let PhotoPreview_BottomToolBarOKButtonColor_Normal = RGBA(0, green: 220, blue: 0, alpha: 1)

let PhotoPreview_BottomToolBarNumberOfSelectedLabelHeight: CGFloat = 20
let PhotoPreview_BottomToolBarFontSize: CGFloat = 16

let PhotoPreview_MaxWidth: CGFloat = 600 // Default is 600

let PhotoPreview_NavBarBgColor = RGBA(100, green: 100, blue: 100, alpha: 0.6)
let PhotoPreview_NavBarHeight: CGFloat = 64

// MARK: Post Photo and Text View
let PostPhoto_CoverPhotoLabelBgColor = RGBA(255, green: 255, blue: 0, alpha: 0.6)
let PostPhoto_TextViewHorizontalMargin: CGFloat = 10
let PostPhoto_CollectionCellMargin: CGFloat = 5
let PostPhoto_NumOfPhotosInARow: Int = 4
let PostPhoto_PhotoAndTextCell_CollectionViewCellItemWidth = (ScreenWidth - 2 * PostPhoto_TextViewHorizontalMargin - (CGFloat(PostPhoto_NumOfPhotosInARow) - 1) * PostPhoto_CollectionCellMargin) / CGFloat(PostPhoto_NumOfPhotosInARow)

let PostPhotoFirstCell_PhotoCollectionCell_Identifier: String = "PostPhotoFirstCell_PhotoCollectionCell_Identifier"
let PostPhotoFirstCell_Identifier: String = "PostPhotoFirstCell_Identifier"
let PostPhotoLocationCell_Identifier: String = "PostPhotoLocationCell_Identifier"

let PostPhotoFirstCell_TextViewHeight: CGFloat = 80
let PostPhotoFirstCell_CollectionViewTopMargin: CGFloat = 10









