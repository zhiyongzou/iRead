//
//  IRBrightnessSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBrightnessSettingView: UIView {

    static let bottomSapcing: CGFloat = 5
    static let viewHeight: CGFloat = 40
    static let totalHeight = bottomSapcing + viewHeight

    var brightnessSlider = UISlider()
    var bigIcon = UIImageView()
    var samllIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    func setupSubviews() {
        
        let margin: CGFloat = 15
        
        self.addSubview(samllIcon)
        samllIcon.backgroundColor = UIColor.randomColor()
        samllIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(margin)
            make.height.width.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(bigIcon)
        bigIcon.backgroundColor = UIColor.randomColor()
        bigIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-margin)
            make.height.width.equalTo(30)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(brightnessSlider)
        brightnessSlider.snp.makeConstraints { (make) in
            make.right.equalTo(bigIcon.snp.left).offset(-5)
            make.left.equalTo(samllIcon.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
    }
}
