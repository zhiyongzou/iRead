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

    static let titleSpacing: CGFloat = 5
    static var progressRadius: CGFloat = 0
    static var progressLineWidth: Double = 8
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var timeDescLabel = UILabel()
    var taskProgress = KYCircularProgress.init(frame: CGRect.zero, showGuide: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = IRHomeTaskCell.progressRadius
        let pi = CGFloat(Double.pi)
        let arcCenter = CGPoint(x: contentView.width / 2, y: radius)
        taskProgress.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: pi, endAngle: pi * 2, clockwise: true)
    }
    
    public var taskModel: IRHomeTaskModel? {
        didSet {
            let readingTime = taskModel?.readingTime ?? 0
            taskProgress.progress = min(1, Double(readingTime) / 3600)
            let minute = min(60, readingTime / 60)
            var sceondString: String
            if minute < 60 {
                sceondString = String(format: "%02d", readingTime - minute * 60)
            } else {
                sceondString = "00"
            }
            timeLabel.text = "\(minute):\(sceondString)"
        }
    }
    
    static var titleAttributedText: NSMutableAttributedString = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        let titleText = NSMutableAttributedString.init(string: "每日阅读", attributes: [.font: UIFont.boldSystemFont(ofSize: 22), .foregroundColor: UIColor.black, .paragraphStyle: paragraphStyle])
        let descText = NSAttributedString.init(string: "\n每天阅读1小时，积少成多，聚沙成塔~", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.hexColor("999999"), .paragraphStyle: paragraphStyle])
        titleText.append(descText)
        return titleText
    }()
    
    class func cellHeight(with maxWidth: CGFloat) -> CGFloat {
        let textHeight = ceil(titleAttributedText.boundingRect(with: CGSize(width: maxWidth - titleSpacing * 2, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height)
        progressRadius = floor(maxWidth / 3)
        return 60 + textHeight + progressRadius + CGFloat(progressLineWidth)
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        titleLabel.attributedText = IRHomeTaskCell.titleAttributedText
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(IRHomeTaskCell.titleSpacing)
            make.right.equalTo(contentView).offset(-IRHomeTaskCell.titleSpacing)
            make.top.equalTo(contentView).offset(20)
        }
        
        taskProgress.strokeStart = 0
        taskProgress.lineWidth = IRHomeTaskCell.progressLineWidth
        taskProgress.lineCap = CAShapeLayerLineCap.round.rawValue
        taskProgress.colors = [.hexColor("A6FFCB"), .hexColor("12D8FA"), .hexColor("1FA2FF")]
        taskProgress.guideColor = .hexColor("99CCCCCC")
        taskProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            print("progress: \(progress)")
        }
        contentView.addSubview(taskProgress)
        taskProgress.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.right.left.equalTo(contentView)
        }
        
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 45)
        timeLabel.text = "00:00"
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(taskProgress)
            make.bottom.equalTo(taskProgress).offset(5)
        }
        
        timeDescLabel.textColor = .black
        timeDescLabel.textAlignment = .center
        timeDescLabel.font = .boldSystemFont(ofSize: 16)
        timeDescLabel.text = "今日阅读进度"
        contentView.addSubview(timeDescLabel)
        timeDescLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(taskProgress)
            make.bottom.equalTo(timeLabel.snp.top)
        }
    }
}
