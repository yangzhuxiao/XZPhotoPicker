//
//  XZAlbumPickerController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/19/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZAlbumPickerController: UIViewController {
    private var albums = NSMutableArray()
    private let tableView = UITableView()
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        style()
        loadData()
    }
}

// MARK: Setup
private extension XZAlbumPickerController {
    func setup() {
        title = "相册"
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.addSubview(tableView)
    }
}

// MARK: Layout
private extension XZAlbumPickerController {
    func layout() {
        constrain(tableView) { (view) in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
    }
}

// MARK: Style
private extension XZAlbumPickerController {
    func style() {
        view.backgroundColor = UIColor.whiteColor()
    }
}

// MARK: Load data
private extension XZAlbumPickerController {
    func loadData() {
        XZImageManager.manager.getAllAlbums { (models: Array<XZAlbumModel>) in
            weak var weakSelf = self
            weakSelf?.albums = NSMutableArray(array: models)
            weakSelf?.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource
extension XZAlbumPickerController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentModel: XZAlbumModel = albums[indexPath.row] as! XZAlbumModel
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell")!
        cell.textLabel?.text = currentModel.name
        return cell
    }
}










