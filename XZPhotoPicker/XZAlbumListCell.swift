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
    private var arrowImageView = UIImageView()
    
    var model: XZAlbumModel? {
        didSet {
            XZImageManager.manager.getAlbumListCellCoverImageWithAlbumModel(self.model!, phWidth: self.frame.size.width) { (coverImage) in
                self.coverImageView.image = coverImage
                self.titleLabel.text = self.model?.name
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
        contentView.addSubview(arrowImageView)
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
        }
        constrain(titleLabel, arrowImageView) { (view1, view2) in
            view2.right == view2.superview!.right - 10
            view2.width == view2.height
            view2.height == rightArrowHeight
            view2.centerY == view2.superview!.centerY
            
            view1.right == view2.left - 10
        }
    }
}

// MARK: Style
private extension XZAlbumListCell {
    func style() {
        contentView.backgroundColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.textColor = UIColor.blackColor()
    }
}
















