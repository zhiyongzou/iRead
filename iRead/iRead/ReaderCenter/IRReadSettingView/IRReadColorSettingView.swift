//
//  IRReadColorSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRReadColorSettingView: UIView, IRSwitchSettingViewDeleagte {

    static let bottomSapcing: CGFloat = 5
    static let viewHeight: CGFloat = 100
    static let totalHeight = bottomSapcing + viewHeight
    lazy var bottomLine = UIView()
    lazy var systemFollowView = IRSwitchSettingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    func setupSubviews() {
        
        systemFollowView.titleLabel.textColor = IRReaderConfig.textColor
        systemFollowView.titleLabel.text = "跟随系统深色模式"
        systemFollowView.isOn = UserDefaults.standard.bool(forKey: kReadFollowSystemTheme)
        systemFollowView.delegate = self
        self.addSubview(systemFollowView)
        systemFollowView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(IRSwitchSettingView.viewHeight)
        }
        
        bottomLine.backgroundColor = IRSeparatorColor
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(systemFollowView.snp.top)
        }
    }
    
    //MARK: - IRSwitchSettingViewDeleagte
    func pageScrollSettingView(_ view: IRSwitchSettingView, isOn: Bool) {
        
    }
}
