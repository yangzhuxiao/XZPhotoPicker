//
//  XZAlbumListCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/20/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class XZAlbumListCell: UITableViewCell {
    private let titleLabel = UILabel()
    private var coverImageView = UIImageView()
    
    var model: XZAlbumModel? {
        didSet {
            if (model != nil) {
                let albumName: NSMutableAttributedString = NSMutableAttributedString(string: model!.name as String, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(16), NSForegroundColorAttributeName: UIColor.blackColor()])
                let countString: NSMutableAttributedString = NSMutableAttributedString(string: "  (" + String(model!.count) + ")", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                albumName.appendAttributedString(countString)
                titleLabel.attributedText = albumName
            }
            
            XZImageManager.manager.getAlbumListCellCoverImageWithAlbumModel(model!, phWidth: AlbumListRowHeight) { (coverImage) in
                self.coverImageView.image = coverImage
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        layoutView()
        style()
    }
}

// MARK: Setup
private extension XZAlbumListCell {
    func setup() {
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        contentView.addSubview(coverImageView)
    }
}

// MARK: Layout
private extension XZAlbumListCell {
    func layoutView() {
        constrain(coverImageView) { (view) in
            view.left == view.superview!.left
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.height == view.superview!.height
            view.height == view.width
        }
        constrain(titleLabel, coverImageView) { (view1, view2) in
            view1.left == view2.right + 10
            view1.centerY == view1.superview!.centerY
            view1.right == view1.superview!.right - 50
        }
    }
}

// MARK: Style
private extension XZAlbumListCell {
    func style() {
        contentView.backgroundColor = UIColor.whiteColor()
        coverImageView.contentMode = UIViewContentMode.ScaleAspectFill
        coverImageView.clipsToBounds = true
    }
}
















