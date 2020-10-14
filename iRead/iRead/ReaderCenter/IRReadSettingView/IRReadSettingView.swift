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
        scrollSettingView.title.textColor = IRReaderConfig.textColor
        scrollSettingView.title.text = "竖向翻页"
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
    }
    
    //MARK: - Public
    class var viewSize: CGSize {
        get {
            let height = IRSwitchSettingView.viewHeight + IRReadColorSettingView.viewHeight
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
