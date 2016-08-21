//
//  Constants.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/20/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit

let ScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let ScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height

func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha/1.0)
}

let NavBgColor = RGBA(65, green: 65, blue: 65, alpha: 1)

// MARK: Album List View
let AlbumListRowHeight: CGFloat = 60
let AlbumListTitleFontSize: CGFloat = 17
let AlbumListCell_Identifier: String = "AlbumListCell"

// MARK: Photo Collection View
let PhotoCollectionCell_NumOfPhotosInARow: Int = 4
let PhotoCollectionCell_ClickableAreaRatio: CGFloat = 0.4
let PhotoCollectionCell_CheckMarkImageSize: CGSize = CGSize(width: 27, height: 27) // 选择对号大小
let PhotoCollectionCell_CheckMarkImageMargin: CGFloat = 2 // 选择对号上、右边距

let PhotoCollectionCell_XMargin: CGFloat = 2 // collectionViewCell左右侧间距
let PhotoCollectionCell_YMargin = PhotoCollectionCell_XMargin // collectionViewCell上下侧间距
let PhotoCollectionCell_PhotoWidth: Double = (Double(ScreenWidth) - (Double(PhotoCollectionCell_NumOfPhotosInARow - 1) + 2) * Double(PhotoCollectionCell_XMargin)) / 4
let PhotoCollectionCell_Identifier: String = "PhotoCollectionCell"

let PhotoCollection_BottomToolBarBgColor = RGBA(250, green: 250, blue: 250, alpha: 1)
let PhotoCollection_BottomToolBarSeparatorColor = RGBA(180, green: 180, blue: 180, alpha: 1)
let PhotoCollection_BottomToolBarHeight: CGFloat = 49
let PhotoCollection_BottomToolBarOKButtonColor = RGBA(0, green: 220, blue: 0, alpha: 1)
let PhotoCollection_BottomToolBarNumberOfSelectedLabelHeight: CGFloat = 20
let PhotoCollection_BottomToolBarFontSize: CGFloat = 16












