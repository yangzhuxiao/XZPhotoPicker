//
//  XZImageManager.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/20/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos

class XZImageManager: NSObject {
    class var manager: XZImageManager {
        dispatch_once(&Static.onceToke) {
            Static.instance = XZImageManager()
        }
        return Static.instance!
    }
    private struct Static {
        static var onceToke: dispatch_once_t = 0
        static var instance: XZImageManager?
    }
    
    func testSingleton() {
        let sing1 = XZImageManager.manager
        let sing2 = XZImageManager.manager
        if sing1 === sing2 {
            print("Singleton clas 'XZImageManager' it is!")
        }
    }
    
    func getAllAlbums(completion: (Array<XZAlbumModel>) -> ()) {
        testSingleton()
        let albumArray = NSMutableArray()
        
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumRegular, options: nil)
        let topLevelUserCollections: PHFetchResult = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
        print("smart albums count: \(smartAlbums.count)")
        print("top level user collections count: \(topLevelUserCollections.count)")
        
        let option: PHFetchOptions = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        for i in 0..<smartAlbums.count {
            let collection = smartAlbums[i] as! PHAssetCollection
            print("localized name of each collection inside smartAlbums: \(collection.localizedTitle)")
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: option)

            if fetchResult.count < 1 {
                continue
            }
            if collection.localizedTitle!.containsString("Deleted")
                || collection.localizedTitle == "最近删除" {
                continue
            }
            if collection.localizedTitle == "Camera Roll"
                || collection.localizedTitle == "相机胶卷"
                || collection.localizedTitle == "所有照片"
                || collection.localizedTitle == "All Photos" {
                albumArray.insertObject(modelWithResult(fetchResult, name: collection.localizedTitle!), atIndex: 0)
            } else {
                albumArray.addObject(modelWithResult(fetchResult, name: collection.localizedTitle!))
            }
        }
        
        for i in 0..<topLevelUserCollections.count {
            let collection = topLevelUserCollections[i] as! PHAssetCollection
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: option)
            if fetchResult.count < 1 {
                continue
            }
            albumArray.addObject(modelWithResult(fetchResult, name: collection.localizedTitle!))
        }
        
        if albumArray.count > 0 {
            completion(albumArray as NSArray as! [XZAlbumModel])
        }
    }
    
    func getAlbumListCellCoverImageWithAlbumModel(model: XZAlbumModel, completion: (coverImage: UIImage) -> ()) {
        
    }
}

private extension XZImageManager {
    func modelWithResult(result: PHFetchResult, name: String) -> XZAlbumModel {
        return XZAlbumModel(result: result, name: name, count: result.count)
    }
}



















