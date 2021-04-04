//
//  BSMenuCell.swift
//  iRead
//
//  Created by zzyong on 2021/3/14.
//  Copyright © 2021 zzyong. All rights reserved.
//

import UIKit
import SnapKit

class BSMenuCell: UICollectionViewCell {
    
    var iconView = UIImageView()
    var titleLabel = UILabel()
    var bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    var menuModel: BSMenuModel? {
        didSet {
            guard let menuModel = menuModel else {
                iconView.image = nil
                titleLabel.text = nil
                return
            }
            iconView.image = UIImage(named: menuModel.imageName)
            titleLabel.text = menuModel.title
        }
    }
    
    var hiddenBottomLine: Bool = false {
        didSet {
            bottomLine.isHidden = hiddenBottomLine
        }
    }
    
    private func setupSubviews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(contentView)
            make.width.height.equalTo(16)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = .hexColor("333333")
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(contentView)
            make.left.equalTo(iconView.snp.right).offset(8)
        }
        
        bottomLine.backgroundColor = .hexColor("eeeeee")
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.height.equalTo(1)
            make.left.equalTo(iconView)
            make.right.equalTo(titleLabel)
        }
    }
}
