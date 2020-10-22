//
//  IRReadSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

protocol IRReadSettingViewDelegate: AnyObject {
    func readSettingView(_ view: IRReadSettingView, transitionStyleDidChagne newValue: IRTransitionStyle)
    
    func readSettingView(_ view: IRReadSettingView, didChangeSelectColor color: IRReadColorModel)
    
    func readSettingView(_ view: IRReadSettingView, didChangeTextSizeMultiplier textSizeMultiplier: Int)
    
    func readSettingView(_ view: IRReadSettingView, didSelectFontName fontName: String)
}

class IRReadSettingView: UIView, IRSwitchSettingViewDeleagte, IRReadColorSettingViewDelegate, IRFontSettingViewDelegate, IRFontSelectViewDelegate {
    
    weak var deleage: IRReadSettingViewDelegate?
    
    var fontSelectView: IRFontSelectView?
    var contentView = UIView()
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
    
    override func willMove(toWindow newWindow: UIWindow?) {
        
        if newWindow == nil && fontSelectView?.superview != nil {
            fontSelectView?.dissmissAnimated(false)
        }
        
        super.willMove(toWindow: newWindow)
    }
    
    //MARK: - Private
    func setupSubviews() {
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        scrollSettingView.titleLabel.text = "竖向翻页"
        scrollSettingView.isOn = IRReaderConfig.transitionStyle == .scroll
        scrollSettingView.delegate = self
        contentView.addSubview(scrollSettingView)
        scrollSettingView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(self)
            make.height.equalTo(IRSwitchSettingView.viewHeight)
        }
        
        colorSettingView.delegate = self
        contentView.addSubview(colorSettingView)
        colorSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(scrollSettingView.snp.top).offset(-IRReadColorSettingView.bottomSapcing)
            make.height.equalTo(IRReadColorSettingView.viewHeight)
        }
        
        fontSettingView.delegate = self
        contentView.addSubview(fontSettingView)
        fontSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(colorSettingView.snp.top).offset(-IRFontSettingView.bottomSapcing)
            make.height.equalTo(IRFontSettingView.viewHeight)
        }
        
        contentView.addSubview(brightnessSettingView)
        brightnessSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.bottom.equalTo(fontSettingView.snp.top).offset(-IRBrightnessSettingView.bottomSapcing)
            make.height.equalTo(IRBrightnessSettingView.viewHeight)
        }
        
        self.updateViewBackgroungColor(byPageColorHex: IRReaderConfig.pageColorHex)
    }
    
    func updateViewBackgroungColor(byPageColorHex pageHex: String) {
        
        contentView.backgroundColor = IRReaderConfig.pageColor
        self.backgroundColor = IRReaderConfig.bgColor
        
        fontSelectView?.backgroundColor = IRReaderConfig.bgColor
        fontSettingView.backgroundColor = IRReaderConfig.bgColor
        scrollSettingView.backgroundColor = IRReaderConfig.bgColor
        brightnessSettingView.backgroundColor = IRReaderConfig.bgColor
        colorSettingView.backgroundColor = IRReaderConfig.bgColor
        
        fontSettingView.updateTextColor(IRReaderConfig.textColor, separatorColor:IRReaderConfig.separatorColor)
        colorSettingView.updateTextColor(IRReaderConfig.textColor, separatorColor:IRReaderConfig.separatorColor)
        scrollSettingView.titleLabel.textColor = IRReaderConfig.textColor
        fontSelectView?.updateTextColor(IRReaderConfig.textColor, separatorColor: IRReaderConfig.separatorColor)
    }
    
    //MARK: - Public
    class var viewSize: CGSize {
        get {
            let height = IRSwitchSettingView.viewHeight + IRReadColorSettingView.totalHeight + IRFontSettingView.totalHeight + IRBrightnessSettingView.totalHeight
            return CGSize.init(width: 300, height: height)
        }
    }
    
    //MARK: - IRFontSelectViewDelegate
    func fontSelectView(_ view: IRFontSelectView, didSelectFontName fontName: String) {
        
        if IRReaderConfig.fontName?.rawValue == fontName {
            return
        }
        IRReaderConfig.fontName = IRReadTextFontName(rawValue: fontName)
        fontSettingView.fontTypeSelectView.detailText = IRReaderConfig.fontName?.displayName()
        self.deleage?.readSettingView(self, didSelectFontName: fontName)
    }
    
    //MARK: - IRSwitchSettingViewDeleagte
    func switchSettingView(_ view: IRSwitchSettingView, isOn: Bool) {
        IRReaderConfig.transitionStyle = isOn ? .scroll : .pageCurl
        UserDefaults.standard.set(IRReaderConfig.transitionStyle.rawValue, forKey: kReadTransitionStyle)
        self.deleage?.readSettingView(self, transitionStyleDidChagne: IRReaderConfig.transitionStyle)
    }
    
    //MARK: - IRReadColorSettingViewDelegate
    func readColorSettingView(_ view: IRReadColorSettingView, didChangeSelectColor color: IRReadColorModel) {
        IRReaderConfig.pageColorHex = color.pageColorHex
        self.updateViewBackgroungColor(byPageColorHex: color.pageColorHex)
        self.deleage?.readSettingView(self, didChangeSelectColor: color)
    }
    
    func readColorSettingView(_ view: IRReadColorSettingView, isFollowSystemTheme isFollow: Bool) {
        
    }
    
    //MARK: - IRFontSettingViewDelegate
    func fontSettingView(_ view: IRFontSettingView, didChangeTextSizeMultiplier textSizeMultiplier: Int) {
        self.deleage?.readSettingView(self, didChangeTextSizeMultiplier: textSizeMultiplier)
        UserDefaults.standard.set(textSizeMultiplier, forKey: kReadTextSizeMultiplier)
    }
    
    func fontSettingViewDidClickFontSelect(_ view: IRFontSettingView) {
        
        if fontSelectView == nil {
            fontSelectView = IRFontSelectView()
            fontSelectView?.delegate = self
            fontSelectView?.backgroundColor = self.backgroundColor
        }
        
        self.addSubview(fontSelectView!)
        fontSelectView?.frame = CGRect.init(x: self.width, y: 0, width: self.width, height: self.height)
        UIView.animate(withDuration: 0.25) {
            self.fontSelectView?.x = 0
        }
    }
}
