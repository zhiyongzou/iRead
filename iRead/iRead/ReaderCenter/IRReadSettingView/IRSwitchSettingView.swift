//
//  IRPageScrollSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

protocol IRSwitchSettingViewDeleagte: AnyObject {
    func switchSettingView(_ view: IRSwitchSettingView, isOn: Bool)
}

class IRSwitchSettingView: UIView {

    static let viewHeight: CGFloat = 42
    
    weak var delegate: IRSwitchSettingViewDeleagte?
    
    var titleLabel = UILabel()
    var scrollSwitch = UISwitch()
    
    var isOn: Bool = false {
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
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(margin)
            make.centerY.equalTo(self)
        }
        
        scrollSwitch.isOn = isOn
        self.addSubview(scrollSwitch)
        scrollSwitch.addTarget(self, action: #selector(didSwitchValueChange(switchView:)), for: .valueChanged)
        scrollSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-margin)
            make.centerY.equalTo(self)
        }
    }
    
    @objc func didSwitchValueChange(switchView: UISwitch) {
        self.delegate?.switchSettingView(self, isOn: switchView.isOn)
    }
}
