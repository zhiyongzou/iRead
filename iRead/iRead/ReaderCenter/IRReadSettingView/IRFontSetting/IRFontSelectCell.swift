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
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                self.contentView.backgroundColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 0.5)
            } else {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }
    
    var fontModel: IRFontModel? {
        willSet {
            guard let font = newValue else { return }
            titleLabel.textColor = IRReaderConfig.textColor
            if font.isDownload {
                titleLabel.font = UIFont.init(name: font.fontName, size: 20)
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 20)
            }
            separatorLine.backgroundColor = IRReaderConfig.separatorColor
            titleLabel.text = font.dispalyName
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
