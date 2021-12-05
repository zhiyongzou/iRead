//
//  IRObjectiveCell.swift
//  iRead
//
//  Created by zzyong on 2021/12/5.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit
import SnapKit

class IRObjectiveCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var timeLabel = UILabel()
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
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(16)
            make.left.equalTo(titleLabel.snp.right)
        }
        
        timeLabel.textAlignment = .right
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.right.equalTo(contentView).offset(-15)
        }
    }
    
    var objectiveModel: IRObjectiveModel? {
        didSet {
            var timeText = "0"
            if let time = objectiveModel?.time {
                timeText = "\(time)"
            }
            let timeAtt = NSMutableAttributedString.init(string: timeText, attributes: [.font: UIFont.boldSystemFont(ofSize: 22), .foregroundColor: UIColor.black])
            let minText = NSMutableAttributedString.init(string: " 分钟", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.rgba(155, 155, 155)])
            timeAtt .append(minText)
            timeLabel.attributedText = timeAtt
            titleLabel.text = objectiveModel?.title
            iconBgView.backgroundColor = objectiveModel?.iconBgColor
            if let imageName = objectiveModel?.iconName {
                iconView.image = UIImage(named: imageName)
            }
        }
    }
}

