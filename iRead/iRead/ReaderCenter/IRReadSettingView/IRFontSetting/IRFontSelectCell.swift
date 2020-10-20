//
//  IRFontSelectCell.swift
//  iRead
//
//  Created by zzyong on 2020/10/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRFontSelectCell: UICollectionViewCell {
    
    static let cellHeight: CGFloat = 45
    var selectView: UIImageView?
    var titleLabel = UILabel()
    var separatorLine = UIView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    var fontModel: IRFontModel? {
        willSet {
            titleLabel.textColor = IRReaderConfig.textColor
            separatorLine.backgroundColor = IRReaderConfig.separatorColor
            titleLabel.text = newValue?.dispalyName
        }
    }
    
    private func setupSubviews() {
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(40)
        }
        
        self.contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
