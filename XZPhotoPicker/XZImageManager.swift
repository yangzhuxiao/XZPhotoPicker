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
            
            if ScreenWidth > 700 {
                ImageScaleFactor = 1.5
            } else {
                ImageScaleFactor = 2
            }
            
        }
        return Static.instance!
    }
    private struct Static {
        static var onceToke: dispatch_once_t = 0
        static var instance: XZImageManager?
    }
    
    // for testing if it is a singleton class
    func testSingleton() {
        let sing1 = XZImageManager.manager
        let sing2 = XZImageManager.manager
        if sing1 === sing2 {
//            print("Singleton clas 'XZImageManager' it is!")
        }
    }
}

// MARK: Authorization
extension XZImageManager {
    func authorizationStatusForAlbum(authorized: ()->(), notDetermined: ()->(), restricted: ()->(), denied: () -> ()) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .Authorized:
            authorized()
        case .Denied:
            denied()
        case .NotDetermined:
            notDetermined()
        case .Restricted:
            restricted()
        }
    }
    func requestAuthorizationForAlbum() {
        PHPhotoLibrary.requestAuthorization {(_) in
        }
    }
    func requestAuthorizationForCamera() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: nil)
    }
    func isAlbumAccessGranted() -> Bool {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            return true
        }
        return false
    }
    func isCameraAccessGranted() -> Bool {
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == AVAuthorizationStatus.Authorized {
            return true
        }
        return false
    }
    func authorizationStatusForCamera(authorized: ()->(), notDetermined: ()->(), restricted: ()->(), denied: () -> ()) {
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            authorized()
        case .Denied:
            denied()
        case .NotDetermined:
            notDetermined()
        case .Restricted:
            restricted()
        }
    }
}

// MARK: get albums
extension XZImageManager {
    func getAllAlbums(completion: (Array<XZAlbumModel>) -> ()) {
        let albumArray = NSMutableArray()
        
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumRegular, options: nil)
        let topLevelUserCollections: PHFetchResult = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
//        print("smart albums count: \(smartAlbums.count)")
//        print("top level user collections count: \(topLevelUserCollections.count)")
        
        let option: PHFetchOptions = PHFetchOptions()
        option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        option.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]

        for i in 0..<smartAlbums.count {
            let collection = smartAlbums[i] as! PHAssetCollection
            
//            print("localized name of each collection inside smartAlbums: \(collection.localizedTitle)")
            
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
}

// MARK: get photos
extension XZImageManager {
    func getAlbumListCellCoverImageWithAlbumModel(model: XZAlbumModel, phWidth: CGFloat, completion: (coverImage: UIImage) -> ()) {
        let coverAsset: PHAsset = model.result.lastObject as! PHAsset
        getPhotoWithAsset(coverAsset, photoWidth: phWidth) { (coverImg) in
            completion(coverImage: coverImg)
        }
    }
    
    func getPhotoWithAsset(asset: PHAsset, completion: (img: UIImage) -> ()) {
        let maxPhotoWidth = ScreenWidth > PhotoPreview_MaxWidth ? PhotoPreview_MaxWidth : ScreenWidth
        getPhotoWithAsset(asset, photoWidth: maxPhotoWidth) { (img) in
            completion(img: img)
        }
    }
    
    func getPhotoWithAsset(asset: PHAsset, photoWidth: CGFloat, completion: (img: UIImage) -> ()) -> PHImageRequestID {
        let imgPixelWidth: CGFloat = photoWidth * ImageScaleFactor
        let imgAspectRatio = CGFloat(asset.pixelWidth)/CGFloat(asset.pixelHeight)
        let imgPixelHeight = imgPixelWidth / imgAspectRatio
        let imgSize = CGSize(width: imgPixelWidth, height: imgPixelHeight)
        
        let requestOption = PHImageRequestOptions()
        requestOption.resizeMode = PHImageRequestOptionsResizeMode.Fast
        
        let imageRequestID = PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: imgSize, contentMode: PHImageContentMode.AspectFill, options: requestOption) { (image, info) in
            completion(img: image!)
        }
        
        return imageRequestID
    }
    
    func getAssetIdentifier(asset: PHAsset) -> String {
        return asset.localIdentifier
    }
    
    func getAssetsFromFetchResult(result: PHFetchResult, completion: (Array<XZAssetModel>) -> ()) {
        var assetsArray: Array<XZAssetModel> = []
        result.enumerateObjectsUsingBlock { (obj, idx, stop) in
            if obj.isKindOfClass(PHAsset.self) {
                let model = XZAssetModel(asset: obj as! PHAsset)
                assetsArray.append(model)
            }
        }
        completion(assetsArray)
    }
    
    func getLastPhotoFromCameraRoll() -> (XZAssetModel) {
        var lastModel: XZAssetModel? = nil
        if let cameraRolls: Array<XZAssetModel> = getCameraRollAlbum()?.models {
            lastModel = cameraRolls[cameraRolls.count - 1]
        }
        return lastModel!
    }
    
    func getCameraRollAlbum() -> (XZAlbumModel?) {
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumRegular, options: nil)
        
        let option: PHFetchOptions = PHFetchOptions()
        option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        option.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]
        
        for i in 0..<smartAlbums.count {
            let collection = smartAlbums[i] as! PHAssetCollection
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: option)
            if collection.localizedTitle == "Camera Roll"
                || collection.localizedTitle == "相机胶卷"
                || collection.localizedTitle == "所有照片"
                || collection.localizedTitle == "All Photos" {
                
                return modelWithResult(fetchResult, name: collection.localizedTitle!)
            }
        }
        return nil
    }
}

private extension XZImageManager {
    func modelWithResult(result: PHFetchResult, name: String) -> XZAlbumModel {
        return XZAlbumModel(result: result, name: name, count: result.count)
    }
}



