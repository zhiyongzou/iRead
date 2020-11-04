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
    var scrollView = UIScrollView()
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
            scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        super.willMove(toWindow: newWindow)
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        scrollView.frame = self.bounds
        scrollView.contentSize = CGSize.init(width: self.width * 2, height: self.height)
        contentView.frame = scrollView.bounds
    }
    
    //MARK: - Private
    func setupSubviews() {
        
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        scrollSettingView.titleLabel.text = "竖向翻页"
        scrollSettingView.isOn = IRReaderConfig.transitionStyle == .scroll
        scrollSettingView.delegate = self
        contentView.addSubview(scrollSettingView)
        scrollSettingView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(contentView)
            make.height.equalTo(IRSwitchSettingView.viewHeight)
        }
        
        colorSettingView.delegate = self
        contentView.addSubview(colorSettingView)
        colorSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(contentView)
            make.bottom.equalTo(scrollSettingView.snp.top).offset(-IRReadColorSettingView.bottomSapcing)
            make.height.equalTo(IRReadColorSettingView.viewHeight)
        }
        
        fontSettingView.delegate = self
        contentView.addSubview(fontSettingView)
        fontSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(contentView)
            make.bottom.equalTo(colorSettingView.snp.top).offset(-IRFontSettingView.bottomSapcing)
            make.height.equalTo(IRFontSettingView.viewHeight)
        }
        
        contentView.addSubview(brightnessSettingView)
        brightnessSettingView.snp.makeConstraints { (make) in
            make.right.left.equalTo(contentView)
            make.bottom.equalTo(fontSettingView.snp.top).offset(-IRBrightnessSettingView.bottomSapcing)
            make.height.equalTo(IRBrightnessSettingView.viewHeight)
        }
        
        self.updateThemeColor()
    }
    
    func updateThemeColor() {
        
        contentView.backgroundColor = IRReaderConfig.pageColor
        self.backgroundColor = IRReaderConfig.bgColor
        
        fontSelectView?.backgroundColor = IRReaderConfig.bgColor
        fontSettingView.backgroundColor = IRReaderConfig.bgColor
        scrollSettingView.backgroundColor = IRReaderConfig.bgColor
        brightnessSettingView.backgroundColor = IRReaderConfig.bgColor
        colorSettingView.backgroundColor = IRReaderConfig.bgColor
        
        fontSettingView.updateTextColor(IRReaderConfig.textColor, separatorColor:IRReaderConfig.separatorColor)
        scrollSettingView.titleLabel.textColor = IRReaderConfig.textColor
        fontSelectView?.updateTextColor(IRReaderConfig.textColor, separatorColor: IRReaderConfig.separatorColor)
    }
    
    //MARK: - Public
    class var viewSize: CGSize {
        get {
            let height = IRSwitchSettingView.viewHeight + IRReadColorSettingView.totalHeight + IRFontSettingView.totalHeight + IRBrightnessSettingView.totalHeight
            return CGSize.init(width: 280, height: height)
        }
    }
    
    //MARK: - IRFontSelectViewDelegate
    func fontSelectView(_ view: IRFontSelectView, didSelectFontName fontName: String) {
        
        if IRReaderConfig.fontName == fontName {
            return
        }
        if IRReaderConfig.isChinese {
            IRReaderConfig.zhFontName = IRReadZHFontName(rawValue: fontName)!
        } else {
            IRReaderConfig.enFontName = IRReadENFontName(rawValue: fontName)!
        }
        fontSettingView.fontTypeSelectView.detailText = IRReaderConfig.fontDispalyName
        self.deleage?.readSettingView(self, didSelectFontName: fontName)
    }
    
    func fontSelectViewDidClickBackButton(_ view: IRFontSelectView) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
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
        self.updateThemeColor()
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
            scrollView.addSubview(fontSelectView!)
            fontSelectView?.frame = CGRect.init(x: self.width, y: 0, width: self.width, height: self.height)
        }
        scrollView.setContentOffset(CGPoint.init(x: self.width, y: 0), animated: true)
    }
}
