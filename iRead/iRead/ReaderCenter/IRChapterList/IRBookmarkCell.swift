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
    var contentLabel = UILabel()
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
                contentView.backgroundColor = UIColor.rgba(200, 200, 200, 0.5)
            } else {
                contentView.backgroundColor = UIColor.clear
            }
        }
    }
    
    var bookmarkModel: IRBookmarkModel? {
        didSet {
            titleLabel.text = bookmarkModel?.chapterName
            timeLabel.text = "刚刚"
            contentLabel.text = bookmarkModel?.content
        }
    }
    
    
    // MARK: - Private
    
    private func setupSubviews() {
        
        let spacing = 20
        titleLabel.textColor = UIColor.rgba(255, 156, 0, 1)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(spacing)
            make.right.equalTo(contentView.snp.right).offset(-spacing)
            make.top.equalTo(contentView).offset(10)
        }
        
        timeLabel.textColor = IRReaderConfig.textColor.withAlphaComponent(0.5)
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        contentLabel.textColor = IRReaderConfig.textColor
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(3)
        }
        
        contentView.addSubview(separatorLine)
        separatorLine.backgroundColor = IRReaderConfig.separatorColor
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
    }
}
