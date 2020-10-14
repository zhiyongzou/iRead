//
//  IRPageScrollSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

protocol IRPageScrollSettingViewDelegate {
    func pageScrollSettingView(_ view: IRSwitchSettingView, scrollEnable: Bool)
}

class IRSwitchSettingView: UIView {

    static let viewHeight: CGFloat = 40
    
    var delegate: IRPageScrollSettingViewDelegate?
    
    var title = UILabel()
    var scrollSwitch = UISwitch()
    
    var scrollEnable: Bool = false {
        willSet {
            scrollSwitch.isOn = newValue
        }
    }
    
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
        
        title.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(margin)
            make.centerY.equalTo(self)
        }
        
        scrollSwitch.isOn = scrollEnable
        self.addSubview(scrollSwitch)
        scrollSwitch.addTarget(self, action: #selector(didSwitchValueChange(switchView:)), for: .valueChanged)
        scrollSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-margin)
            make.centerY.equalTo(self)
        }
    }
    
    @objc func didSwitchValueChange(switchView: UISwitch) {
        self.delegate?.pageScrollSettingView(self, scrollEnable: switchView.isOn)
    }
}
