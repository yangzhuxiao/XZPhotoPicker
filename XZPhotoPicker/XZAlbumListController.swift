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
//        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
}

// MARK: Setup
private extension XZAlbumListController {
    func setup() {
        title = "相册"
        
        tableView.registerClass(XZAlbumListCell.self, forCellReuseIdentifier: AlbumListCell_Identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = AlbumListRowHeight
        view.addSubview(tableView)
        
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(XZAlbumListController.cancelButtonPressed(_:)))
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
        tableView.tableFooterView = UIView()
    }
}

// MARK: Load data
private extension XZAlbumListController {
    func loadData() {
        weak var weakSelf = self
        XZImageManager.manager.getAllAlbums { (models: Array<XZAlbumModel>) in
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(AlbumListCell_Identifier) as! XZAlbumListCell
        cell.model = currentModel
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}

// MARK: UITableViewDelegate
extension XZAlbumListController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedModel: XZAlbumModel = albums[indexPath.row] as! XZAlbumModel
        navigationController?.pushViewController(XZPhotoCollectionController(model: selectedModel),
                                                 animated: true)
    }
}

// MARK: Actions
extension XZAlbumListController {
    func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {
            EmptySelectedAssets()
        }
    }
}







