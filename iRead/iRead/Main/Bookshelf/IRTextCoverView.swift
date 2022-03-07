//
//  IRTextCoverView.swift
//  iRead
//
//  Created by zzyong on 2022/3/5.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import SnapKit

class IRTextCoverView: UIView {
    
    let nameFontSize = 17.0
    let authorFontSize = 14.0
    
    var gradientBg: CAGradientLayer = {
        let gradient = CAGradientLayer()
        // startPoint 和 endPoint 属性，他们决定了渐变的方向，左上角坐标是{0, 0}，右下角坐标是{1, 1}
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [UIColor.clear, UIColor.init(white: 0, alpha: 0.5).cgColor, UIColor.init(white: 0, alpha: 0.8).cgColor,]
        return gradient
    }()

    lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: nameFontSize)
        label.textColor = .white
        return label
    }()
    
    lazy var authorLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: authorFontSize)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBg.frame = bounds
    }
    
    func setupSubviews() {
        
        backgroundColor = .systemGray
        layer.addSublayer(gradientBg)
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(5)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self.snp.centerY)
        }
        
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    func setBookName(_ name: String?, authorName: String?) {
        nameLabel.text = name
        authorLabel.text = authorName
    }
    
    var fontScale: CGFloat = 1.0 {
        didSet {
            authorLabel.font = UIFont.systemFont(ofSize: authorFontSize * fontScale)
            nameLabel.font = UIFont.systemFont(ofSize: nameFontSize * fontScale)
        }
    }
    
}
