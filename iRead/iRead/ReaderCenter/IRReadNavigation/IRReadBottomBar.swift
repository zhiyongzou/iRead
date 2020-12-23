//
//  IRReadBottomBar.swift
//  iRead
//
//  Created by zzyong on 2020/10/30.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit

protocol IRReadBottomBarDelegate: AnyObject {
    
    func readBottomBar(_: IRReadBottomBar, didChangePageIndex pageIndex: Int)
    func readBottomBar(_: IRReadBottomBar, didEndChangePageIndex pageIndex: Int)
}

class IRReadBottomBar: UIView {

    let barHeight: CGFloat = 40
    
    weak var delegate: IRReadBottomBarDelegate?
    
    /// 当前阅读页码
    var curentPageIdx = 0 {
        didSet {
            self.updatePageInfo()
        }
    }
    
    /// 总页数
    var bookPageCount = 0 {
        didSet {
            readSlider.isUserInteractionEnabled = !(bookPageCount == 1)
            self.updatePageInfo()
        }
    }
    
    /// 解析进度
    var parseProgress: Float = 0 {
        didSet {
            progressView.progress = parseProgress
        }
    }
    
    /// 是否解析完成
    var isParseFinish = false {
        didSet {
            progressView.progress = 0
            readSlider.isHidden = !isParseFinish
            pageInfoLabel.isHidden = !isParseFinish
            self.updateThemeColor()
        }
    }

    var progressView = UIProgressView()
    var readSlider = UISlider()
    var pageInfoLabel = UILabel()
    var topLine = UIView()
    
    //MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    //MARK: - Action
    
    @objc func eadSliderValueDidChange(_ slider: UISlider) {
        self.curentPageIdx = Int(slider.value)
        self.delegate?.readBottomBar(self, didChangePageIndex: curentPageIdx)
    }
    
    @objc func readSliderValueDidEndChange(_ slider: UISlider) {
        self.delegate?.readBottomBar(self, didEndChangePageIndex: curentPageIdx)
    }
    
    //MARK: - Private
    
    func updateThemeColor() {
        self.backgroundColor = IRReaderConfig.pageColor
        pageInfoLabel.textColor = IRReaderConfig.textColor
        readSlider.tintColor = IRReaderConfig.textColor
        topLine.backgroundColor = IRReaderConfig.textColor.withAlphaComponent(0.08)
        
        var progressTintColor: UIColor?
        var trackTintColor: UIColor?
        if isParseFinish {
            progressTintColor = IRReaderConfig.textColor
            trackTintColor = IRReaderConfig.textColor.withAlphaComponent(0.25)
        } else {
            progressTintColor = IRReaderConfig.textColor.withAlphaComponent(0.25)
            trackTintColor = UIColor.clear
        }
        progressView.progressTintColor = progressTintColor
        progressView.trackTintColor = trackTintColor
    }
    
    func updatePageInfo() {
        
        let onlyOnePage = bookPageCount == 1
        readSlider.minimumValue = onlyOnePage ? 0 : 1
        readSlider.maximumValue = onlyOnePage ? 1 : Float(bookPageCount)
        readSlider.setValue(Float(curentPageIdx), animated: false)
        pageInfoLabel.text = "第\(curentPageIdx)页，共\(bookPageCount)页"
        progressView.progress = bookPageCount > 0 ? Float(curentPageIdx) / Float(bookPageCount) : 0
    }
    
    func setupSubviews() {
        
        let spacing: CGFloat = 25
        
        readSlider.isHidden = true
        readSlider.minimumTrackTintColor = UIColor.clear
        readSlider.maximumTrackTintColor = UIColor.clear
        readSlider.touchPointOffset = 8
        readSlider.setThumbImage(UIImage.init(named: "slider_thumb")?.template, for: .normal)
        readSlider.addTarget(self, action: #selector(eadSliderValueDidChange(_:)), for: .valueChanged)
        readSlider.addTarget(self, action: #selector(readSliderValueDidEndChange(_:)), for: .touchUpInside)
        self.addSubview(readSlider)
        readSlider.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(12)
            make.left.equalTo(self).offset(spacing)
            make.right.equalTo(self).offset(-spacing)
        }
        
        self.insertSubview(progressView, belowSubview: readSlider)
        progressView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(2)
            make.centerY.equalTo(readSlider)
            make.left.equalTo(self).offset(spacing)
            make.right.equalTo(self).offset(-spacing)
        }
        
        pageInfoLabel.isHidden = true
        pageInfoLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(pageInfoLabel)
        pageInfoLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(readSlider.snp.bottom).offset(5)
            make.centerX.equalTo(self)
        }
        
        topLine = UIView()
        self.addSubview(topLine)
        topLine.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(self)
        }
        
        self.updateThemeColor()
    }
}
