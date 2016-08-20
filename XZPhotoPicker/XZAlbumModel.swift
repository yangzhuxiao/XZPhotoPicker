//
//  XZAlbumModel.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/19/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import Photos

class XZAlbumModel: NSObject {
    var name: String?
    var count: Int?
    var result: PHFetchResult? // PHFetchResult<PHAsset>
    
    init(result: PHFetchResult, name: String, count: Int) {
        self.name = name
        self.result = result
        self.count = result.count
        super.init()
    }
}




