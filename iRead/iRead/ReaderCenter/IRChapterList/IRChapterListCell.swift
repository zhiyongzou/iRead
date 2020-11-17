//
//  IRChapterListCell.swift
//  iRead
//
//  Created by zzyong on 2020/10/26.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib
import SnapKit

class IRChapterListCell: UICollectionViewCell {
    
    let spacing = 20
    var titleLabel = UILabel()
    var separatorLine = UIView()
    
    var tocReference :FRTocReference! {
        didSet {
            titleLabel.text = tocReference.title
            let isSection = tocReference.children.count > 0
            self.backgroundColor = isSection ? IRReaderConfig.separatorColor : UIColor.clear
        }
    }
    
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
                contentView.backgroundColor = UIColor.rgba(200, 200, 200, 0.5)
            } else {
                contentView.backgroundColor = UIColor.clear
            }
        }
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        
        titleLabel.textColor = IRReaderConfig.textColor
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(spacing)
            make.right.equalTo(contentView.snp.right).offset(-spacing)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(separatorLine)
        separatorLine.backgroundColor = IRReaderConfig.separatorColor
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
    }
}
