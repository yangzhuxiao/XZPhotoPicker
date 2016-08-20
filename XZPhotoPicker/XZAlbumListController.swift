//
//  XZAlbumListController.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/20/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Cartography

class XZAlbumListController: UIViewController {
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
private extension XZAlbumListController {
    func setup() {
        title = "相册"
        
        tableView.registerClass(XZAlbumListCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.dataSource = self
        tableView.rowHeight = AlbumListRowHeight
        view.addSubview(tableView)
    }
}

// MARK: Layout
private extension XZAlbumListController {
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
private extension XZAlbumListController {
    func style() {
        view.backgroundColor = UIColor.whiteColor()
    }
}

// MARK: Load data
private extension XZAlbumListController {
    func loadData() {
        XZImageManager.manager.getAllAlbums { (models: Array<XZAlbumModel>) in
            weak var weakSelf = self
            weakSelf?.albums = NSMutableArray(array: models)
            weakSelf?.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource
extension XZAlbumListController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentModel: XZAlbumModel = albums[indexPath.row] as! XZAlbumModel
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell") as! XZAlbumListCell
        cell.model = currentModel
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}
