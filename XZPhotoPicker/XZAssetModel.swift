//
//  XZAssetModel.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/21/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import Photos

class XZAssetModel: NSObject {
    let asset: PHAsset
    var selected: Bool
    
    init(asset: PHAsset) {
        self.asset = asset
        self.selected = false
        super.init()
    }
}
