//
//  XZPostPhotoLocationCell.swift
//  XZPhotoPicker
//
//  Created by Jianing Zheng on 8/29/16.
//  Copyright © 2016 Xiao Zhu. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class XZPostPhotoLocationCell: UITableViewCell {
    private var iconImageView: UIImageView?
    private var nameLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XZPostPhotoLocationCell {
    func setCellContentWithName(name: String?, icon: UIImage?) {
        if nameLabel == nil {
            setup()
            layoutView()
            style()
        }
        nameLabel?.text = name
        iconImageView?.image = icon
    }
}

// MARK: Setup
private extension XZPostPhotoLocationCell {
    func setup() {
        func setupNameLabel() {
            nameLabel = UILabel()
            contentView.addSubview(nameLabel!)
        }
        func setupIconImageView() {
            iconImageView = UIImageView()
            contentView.addSubview(iconImageView!)
        }
        setupNameLabel()
        setupIconImageView()
    }
}

// MARK: Layout
private extension XZPostPhotoLocationCell {
    func layoutView() {
        constrain(iconImageView!, nameLabel!) { (view1, view2) in
            view1.left == view1.superview!.left + PostPhoto_TextViewHorizontalMargin
            view1.centerY == view1.superview!.centerY
            view1.height == view1.width
            view1.height == view1.superview!.height / 2
            
            view2.left == view1.right + PostPhoto_TextViewHorizontalMargin
            view2.centerY == view2.superview!.centerY
            view2.right == view2.superview!.right - PostPhoto_TextViewHorizontalMargin
            view2.height == view2.superview!.height
        }
    }
}

// MARK: Style
private extension XZPostPhotoLocationCell {
    func style() {
        func styleNameLabel() {
            nameLabel?.font = UIFont.systemFontOfSize(15)
            nameLabel?.textColor = UIColor.blackColor()
            nameLabel?.textAlignment = .Left
        }
        func styleIconImageView() {
            iconImageView?.contentMode = .ScaleAspectFill
        }
    }
}














