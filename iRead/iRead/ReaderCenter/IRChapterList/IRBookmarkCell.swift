//
//  IRBookmarkCell.swift
//  iRead
//
//  Created by zzyong on 2020/11/22.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBookmarkCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    
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
    
    var bookmarkModel: IRBookmarkModel? {
        didSet {
            titleLabel.text = bookmarkModel?.chapterName
        }
    }
    
    
    // MARK: - Private
    
    private func setupSubviews() {
        
        let spacing = 20
        titleLabel.textColor = IRReaderConfig.textColor
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(spacing)
            make.right.equalTo(contentView.snp.right).offset(-spacing)
            make.centerY.equalTo(contentView)
        }
        
        timeLabel.textColor = IRReaderConfig.textColor
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(spacing)
            make.right.equalTo(contentView.snp.right).offset(-spacing)
            make.centerY.equalTo(contentView)
        }
    }
}
