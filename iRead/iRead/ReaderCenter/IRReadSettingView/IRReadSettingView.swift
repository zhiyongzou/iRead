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
    func readSettingView(_ view: IRReadSettingView, transitionStyleDidChagne newValue: IRTransitionStyle)
    
    func readSettingView(_ view: IRReadSettingView, didChangeSelectColor color: IRReadColorModel)
}

class IRReadSettingView: UIView, IRSwitchSettingViewDeleagte, IRReadColorSettingViewDelegate {
        
    var deleage: IRReadSettingViewDelegate?
    
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
        
        var selfBgColor: UIColor!
        let textColor = IRReaderConfig.textColor
        var bgColor: UIColor
        var separatorColor: UIColor
        
        switch pageHex {
        case IRReadPageColorHex.HexFFFFFF.rawValue: do {
            bgColor = UIColor.white
            selfBgColor = IRSeparatorColor
            separatorColor = UIColor.init(white: 0, alpha: 0.05)
            }
        case IRReadPageColorHex.HexC9C196.rawValue: do {
            bgColor = UIColor.hexColor("FCF8E9")
            selfBgColor = UIColor.hexColor("E5E2D2")
            separatorColor = UIColor.init(white: 0, alpha: 0.05)
            }
        case IRReadPageColorHex.Hex505050.rawValue: do {
            bgColor = UIColor.hexColor("434343")
            selfBgColor = UIColor.hexColor("323232")
            separatorColor = UIColor.init(white: 1, alpha: 0.05)
            }
        case IRReadPageColorHex.Hex000000.rawValue: do {
            bgColor = UIColor.hexColor("282828")
            selfBgColor = UIColor.black
            separatorColor = UIColor.init(white: 1, alpha: 0.05)
            }
        default:
            bgColor = UIColor.white
            separatorColor = IRSeparatorColor
            selfBgColor = IRSeparatorColor
        }
        
        contentView.backgroundColor = selfBgColor
        self.backgroundColor = bgColor
        
        fontSettingView.backgroundColor = bgColor
        scrollSettingView.backgroundColor = bgColor
        brightnessSettingView.backgroundColor = bgColor
        colorSettingView.backgroundColor = bgColor
        
        fontSettingView.updateTextColor(textColor, separatorColor:separatorColor)
        colorSettingView.updateTextColor(textColor, separatorColor:separatorColor)
        scrollSettingView.titleLabel.textColor = textColor
    }
    
    //MARK: - Public
    class var viewSize: CGSize {
        get {
            let height = IRSwitchSettingView.viewHeight + IRReadColorSettingView.totalHeight + IRFontSettingView.totalHeight + IRBrightnessSettingView.totalHeight
            return CGSize.init(width: 300, height: height)
        }
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
        IRReaderConfig.textColorHex = color.textColorHex
        self.updateViewBackgroungColor(byPageColorHex: color.pageColorHex)
        self.deleage?.readSettingView(self, didChangeSelectColor: color)
    }
    
    func readColorSettingView(_ view: IRReadColorSettingView, isFollowSystemTheme isFollow: Bool) {
        
    }
}
