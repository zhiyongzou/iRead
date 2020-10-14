//
//  IRReadSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

protocol IRReadSettingViewDelegate {
    func readSettingView(_ view:IRReadSettingView, transitionStyleDidChagne newValue: IRTransitionStyle)
}

class IRReadSettingView: UIView, IRSwitchSettingViewDeleagte {
        
    var deleage: IRReadSettingViewDelegate?
    
    lazy var scrollSettingView = IRSwitchSettingView()
    lazy var colorSettingView = IRReadColorSettingView()
    lazy var fontSettingView = IRFontSettingView()
    lazy var brightnessSettingView = IRBrightnessSettingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    //MARK: - Private
    func setupSubviews() {
        
        self.backgroundColor = IRSeparatorColor
        
        scrollSettingView.backgroundColor = IRReaderConfig.pageColor
        scrollSettingView.titleLabel.textColor = IRReaderConfig.textColor
        scrollSettingView.titleLabel.text = "竖向翻页"
        scrollSettingView.isOn = IRReaderConfig.transitionStyle == .scroll
        scrollSettingView.delegate = self
        self.addSubview(scrollSettingView)
        scrollSettingView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(IRSwitchSettingView.viewHeight)
        }
        
        colorSettingView.backgroundColor = IRReaderConfig.pageColor
        self.addSubview(colorSettingView)
        colorSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(scrollSettingView.snp.top).offset(-IRReadColorSettingView.bottomSapcing)
            make.height.equalTo(IRReadColorSettingView.viewHeight)
        }
        
        fontSettingView.backgroundColor = IRReaderConfig.pageColor
        self.addSubview(fontSettingView)
        fontSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(colorSettingView.snp.top).offset(-IRFontSettingView.bottomSapcing)
            make.height.equalTo(IRFontSettingView.viewHeight)
        }
        
        brightnessSettingView.backgroundColor = IRReaderConfig.pageColor
        self.addSubview(brightnessSettingView)
        brightnessSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(fontSettingView.snp.top).offset(-IRBrightnessSettingView.bottomSapcing)
            make.height.equalTo(IRBrightnessSettingView.viewHeight)
        }
    }
    
    //MARK: - Public
    class var viewSize: CGSize {
        get {
            let height = IRSwitchSettingView.viewHeight + IRReadColorSettingView.totalHeight + IRFontSettingView.totalHeight + IRBrightnessSettingView.totalHeight
            return CGSize.init(width: 300, height: height)
        }
    }
    
    //MARK: - IRSwitchSettingViewDeleagte
    func pageScrollSettingView(_ view: IRSwitchSettingView, isOn: Bool) {
        IRReaderConfig.transitionStyle = isOn ? .scroll : .pageCurl
        UserDefaults.standard.set(IRReaderConfig.transitionStyle.rawValue, forKey: kReadTransitionStyle)
        self.deleage?.readSettingView(self, transitionStyleDidChagne: IRReaderConfig.transitionStyle)
    }

}
