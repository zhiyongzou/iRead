//
//  IRBookshelfCell.swift
//  iRead
//
//  Created by zzyong on 2021/12/4.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import SnapKit

class IRBookshelfCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var bookCountLabel = UILabel()
    var iconBgView = UIView()
    var iconView = UIImageView()
    var arrowView = UIImageView(image: UIImage(named: "arrow_grey_right"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        let iconBgW = 33.0
        let iconBgSpacing = 10.0
        iconBgView.layer.cornerRadius = iconBgW / 2
        contentView.addSubview(iconBgView)
        iconBgView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(iconBgSpacing)
            make.left.equalTo(contentView).offset(iconBgSpacing)
            make.width.height.equalTo(iconBgW)
        }
        
        let iconW = 20.0
        iconBgView.addSubview(iconView)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.snp.makeConstraints { make in
            make.center.equalTo(iconBgView)
            make.width.height.equalTo(iconW)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .rgba(118, 118, 122)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconBgView)
            make.top.equalTo(iconBgView.snp.bottom).offset(12)
        }
        
        contentView.addSubview(arrowView)
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(16)
            make.right.equalTo(contentView).offset(-15)
        }
        
        bookCountLabel.textColor = .black
        contentView.addSubview(bookCountLabel)
        bookCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(arrowView.snp.left).offset(-5)
        }
    }
    
    var cellModel: IRBookshelfModel? {
        didSet {
            var bookCountText = "0"
            if let bookCount = cellModel?.bookCount {
                bookCountText = "\(bookCount)"
            }
            let countAtt = NSMutableAttributedString.init(string: bookCountText, attributes: [.font: UIFont.boldSystemFont(ofSize: 22), .foregroundColor: UIColor.black])
            let suffixText = NSMutableAttributedString.init(string: " 本", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.rgba(155, 155, 155)])
            countAtt.append(suffixText)
            bookCountLabel.attributedText = countAtt
            titleLabel.text = cellModel?.title
            iconBgView.backgroundColor = cellModel?.iconBgColor
            if let imageName = cellModel?.iconName {
                iconView.image = UIImage(named: imageName)?.template
            }
        }
    }
}

