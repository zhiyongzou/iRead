//
//  IRReadSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

protocol IRReadSettingViewDelegate {
    func readSettingView(_ view:IRReadSettingView, transitionStyleDidChagne newValue: IRTransitionStyle)
}

class IRReadSettingView: UIView, IRPageScrollSettingViewDelegate {
        
    var deleage: IRReadSettingViewDelegate?
    
    lazy var scrollSettingView = IRSwitchSettingView()
    
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
        scrollSettingView.title.textColor = IRReaderConfig.textColor
        scrollSettingView.title.text = "竖向翻页"
        scrollSettingView.scrollEnable = IRReaderConfig.transitionStyle == .scroll
        scrollSettingView.delegate = self
        self.addSubview(scrollSettingView)
        scrollSettingView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(IRSwitchSettingView.viewHeight)
        }
    }
    
    //MARK: - Public
    class var viewSize: CGSize {
        get {
            let height = IRSwitchSettingView.viewHeight
            return CGSize.init(width: 300, height: height)
        }
    }
    
    //MARK: - IRPageScrollSettingViewDelegate
    func pageScrollSettingView(_ view: IRSwitchSettingView, scrollEnable: Bool) {
        IRReaderConfig.transitionStyle = scrollEnable ? .scroll : .pageCurl
        UserDefaults.standard.set(IRReaderConfig.transitionStyle.rawValue, forKey: kReadTransitionStyle)
        self.deleage?.readSettingView(self, transitionStyleDidChagne: IRReaderConfig.transitionStyle)
    }

}
