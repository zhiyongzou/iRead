//
//  IRFontSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRFontSettingView: UIView {

    static let bottomSapcing: CGFloat = 5
    static let viewHeight: CGFloat = IRArrowSettingView.viewHeight + 40
    static let totalHeight = bottomSapcing + viewHeight
    
    var fontTypeSelectView = IRArrowSettingView()
    lazy var bottomLine = UIView()
    lazy var midLine = UIView()
    var increaseBtn = UIButton.init(type: .custom)
    var reduceBtn = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    @objc func didIncreaseBtnClick() {
        
    }
    
    @objc func didReduceBtnClick() {
        
    }
    
    func setupSubviews() {
        
        fontTypeSelectView.titleLabel.textColor = IRReaderConfig.textColor
        fontTypeSelectView.titleLabel.text = "字体"
        fontTypeSelectView.detailText = "宋体"
        self.addSubview(fontTypeSelectView)
        fontTypeSelectView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(IRArrowSettingView.viewHeight)
        }
        
        bottomLine.backgroundColor = IRSeparatorColor
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(fontTypeSelectView.snp.top)
        }
        
        increaseBtn.setTitle("A", for: .normal)
        increaseBtn.addTarget(self, action: #selector(didIncreaseBtnClick), for: .touchUpInside)
        increaseBtn.contentHorizontalAlignment = .center
        increaseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        increaseBtn.setTitleColor(IRReaderConfig.textColor, for: .normal)
        increaseBtn.setTitleColor(IRReaderConfig.textColor.withAlphaComponent(0.5), for: .highlighted)
        self.addSubview(increaseBtn)
        increaseBtn.snp.makeConstraints { (make) -> Void in
            make.right.top.equalTo(self)
            make.bottom.equalTo(fontTypeSelectView.snp.top)
            make.left.equalTo(self.snp.centerX)
        }
        
        midLine.backgroundColor = IRSeparatorColor
        self.addSubview(midLine)
        midLine.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.height.top.equalTo(increaseBtn)
            make.width.equalTo(1)
        }
        
        reduceBtn.setTitle("A", for: .normal)
        reduceBtn.addTarget(self, action: #selector(didReduceBtnClick), for: .touchUpInside)
        reduceBtn.contentHorizontalAlignment = .center
        reduceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        reduceBtn.setTitleColor(IRReaderConfig.textColor, for: .normal)
        reduceBtn.setTitleColor(IRReaderConfig.textColor.withAlphaComponent(0.5), for: .highlighted)
        self.addSubview(reduceBtn)
        reduceBtn.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(self)
            make.bottom.equalTo(increaseBtn)
            make.right.equalTo(self.snp.centerX)
        }
    }
    
}
