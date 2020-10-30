//
//  IRReadBottomBar.swift
//  iRead
//
//  Created by zzyong on 2020/10/30.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit

class IRReadBottomBar: UIView {

    let barHeight: CGFloat = 44.0
    
    /// 当前阅读页码
    var curentPageIdx = 0 {
        didSet {
            self.updatePageInfo()
        }
    }
    
    /// 总页数
    var bookPageCount = 0 {
        didSet {
            self.updatePageInfo()
        }
    }
    
    /// 解析进度
    var parseProgress: Float = 0 {
        willSet {
            progressView.progress = newValue
        }
    }
    
    /// 是否解析完成
    var isParseFinish = false {
        willSet {
            progressView.progress = 0
            progressView.progressTintColor = newValue ? IRReaderConfig.textColor : UIColor.lightGray
            progressView.trackTintColor = newValue ? UIColor.lightGray : UIColor.clear
            readSlider.isHidden = !newValue
            pageInfoLabel.isHidden = !newValue
        }
    }

    var progressView = UIProgressView()
    var readSlider = UISlider()
    var pageInfoLabel = UILabel()
    
    //MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    func updatePageInfo() {
        readSlider.maximumValue = Float(bookPageCount)
        readSlider.value = Float(curentPageIdx)
        pageInfoLabel.text = "第\(curentPageIdx)页，共\(bookPageCount)页"
        progressView.progress = bookPageCount > 0 ? Float(curentPageIdx) / Float(bookPageCount) : 0
    }
    
    func setupSubviews() {
        
        let spacing: CGFloat = 25
        
        readSlider.isHidden = true
        readSlider.minimumValue = 0
        readSlider.minimumTrackTintColor = UIColor.clear
        readSlider.maximumTrackTintColor = UIColor.clear
        readSlider.setThumbImage(UIImage.init(named: "slider_thumb"), for: .normal)
        self.addSubview(readSlider)
        readSlider.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(spacing)
            make.right.equalTo(self).offset(-spacing)
        }
        
        progressView.progressTintColor = isParseFinish ? UIColor.red : UIColor.lightGray
        progressView.trackTintColor = isParseFinish ? UIColor.lightGray : UIColor.clear
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
    }
}
