//
//  IRHomeTaskCell.swift
//  iRead
//
//  Created by zzyong on 2020/12/24.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit
import QuartzCore.CAShapeLayer

class IRHomeTaskCell: UICollectionViewCell {

    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var timeDescLabel = UILabel()
    var taskProgress = KYCircularProgress.init(frame: CGRect.zero, showGuide: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = CGFloat(contentView.width / 3)
        taskProgress.path = UIBezierPath(arcCenter: CGPoint(x: contentView.center.x, y: radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    }
    
    public var taskModel: IRHomeTaskModel? {
        didSet {
            taskProgress.progress = taskModel?.progress ?? 0
        }
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        let titleText = NSMutableAttributedString.init(string: "今日阅读", attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black, .paragraphStyle: paragraphStyle])
        let descText = NSAttributedString.init(string: "\n坚持每天阅读1小时，以获取更多的知识和乐趣~", attributes: [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.lightGray, .paragraphStyle: paragraphStyle])
        titleText.append(descText)
        titleLabel.attributedText = titleText
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(20)
        }
        
        taskProgress.strokeStart = 0
        taskProgress.lineCap = CAShapeLayerLineCap.round.rawValue
        taskProgress.colors = [.hexColor("A6FFCB"), .hexColor("12D8FA"), .hexColor("1FA2FF")]
        taskProgress.guideColor = .hexColor("99CCCCCC")
        taskProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            print("progress: \(progress)")
        }
        contentView.addSubview(taskProgress)
        taskProgress.snp.makeConstraints { (make) in
            make.height.equalTo(contentView.snp.width).multipliedBy(0.36)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.right.left.equalTo(contentView)
        }
        
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 45)
        timeLabel.text = "00:00"
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(taskProgress)
        }
        
        timeDescLabel.textColor = .black
        timeDescLabel.textAlignment = .center
        timeDescLabel.font = .systemFont(ofSize: 16)
        timeDescLabel.text = "今日阅读时长"
        contentView.addSubview(timeDescLabel)
        timeDescLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(taskProgress)
            make.bottom.equalTo(timeLabel.snp.top)
        }
    }
}
