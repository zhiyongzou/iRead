//
//  IRHomeTopBar.swift
//  iRead
//
//  Created by zzyong on 2022/1/22.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import CommonLib

class IRHomeTopBar: UIView {

    let searchBarHeight = 38.0
    
    var delegate: IRHomeTopBarDelegate?
    
    var searchBarView: UIView?
    var searchBtn: UIButton?
    var scanBtn: UIButton?
    var settingBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 5.0
        let settingW = 20.0
        let settingX = self.width - settingW - margin
        settingBtn?.frame = CGRect(x: settingX, y: 0, width: settingW, height: self.height)
        
        let searchBarW = settingX - margin * 3
        let searchBarY = (self.height - searchBarHeight) * 0.5
        searchBarView?.frame = CGRect(x: margin, y: searchBarY, width: searchBarW, height: searchBarHeight)
        searchBtn?.frame = searchBarView!.bounds
        
        let scanW = 22.0
        scanBtn?.frame = CGRect(x: searchBarView!.width - scanW - 10, y: 0, width: scanW, height: searchBarHeight)
    }
    
    //MARK: Actions
    
    @objc func didClickSettingButton() {
        delegate?.homeTopBarDidClickSettingButton?(self)
    }

    @objc func didClickScanButton() {
        delegate?.homeTopBarDidClickScanButton?(self)
    }
    
    @objc func didClickSearchButton() {
        delegate?.homeTopBarDidClickSearchButton?(self)
    }
    
    //MARK: Private
    
    func setupSubviews() {
        
        backgroundColor = .clear
        
        searchBarView = UIView()
        searchBarView?.layer.cornerRadius = searchBarHeight * 0.5
        searchBarView?.layer.masksToBounds = true
        searchBarView?.backgroundColor = UIColor.white
        searchBarView?.layer.borderWidth = 1
        searchBarView?.layer.borderColor = UIColor.init(white: 0.9, alpha: 1).cgColor
        addSubview(searchBarView!)
        
        settingBtn = buttonWithImageName("setting", title: nil, sel: #selector(didClickSettingButton))
        settingBtn?.touchPointOffset = 10
        addSubview(settingBtn!)
        
        searchBtn = buttonWithImageName("search_icon", title: "搜索", sel: #selector(didClickSearchButton))
        searchBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchBtn?.setTitleColor(UIColor.hexColor("999999"), for: .normal)
        searchBtn?.contentHorizontalAlignment = .left
        searchBtn?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        searchBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        searchBarView?.addSubview(searchBtn!)
        
        scanBtn = buttonWithImageName("scan_icon", title: nil, sel: #selector(didClickScanButton))
        scanBtn?.touchPointOffset = 10
        searchBarView?.addSubview(scanBtn!)
    }
    
    func buttonWithImageName(_ imageName: String, title:String?, sel: Selector) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: sel, for: .touchUpInside)
        return button
    }
}
