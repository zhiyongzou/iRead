//
//  IRReadNavigationBar.swift
//  iRead
//
//  Created by zzyong on 2020/10/13.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit
import CommonLib

protocol IRReadNavigationBarDelegate: AnyObject {
    
    func readNavigationBar(didClickBack bar: IRReadNavigationBar)
    func readNavigationBar(didClickChapterList bar: IRReadNavigationBar)
    func readNavigationBar(didClickReadSetting bar: IRReadNavigationBar)
    func readNavigationBar(_ bar: IRReadNavigationBar, didSelectBookmark isMark: Bool)
}

class IRReadNavigationBar: UIView {

    let itemHeight: CGFloat = 44.0
    var backButton: UIButton!
    var chapterList: UIButton!
    var readSetting: UIButton!
    var bookmark: UIButton!
    var bottomLine: UIView!
    weak var delegate: IRReadNavigationBarDelegate?
    
    //MARK: - Override
    
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
        
        backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage.init(named: "arrow_back")?.template, for: .normal)
        backButton.addTarget(self, action: #selector(didClickBackButton), for: .touchUpInside)
        self.addSubview(backButton)
        backButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(itemHeight)
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(10)
        }
        
        chapterList = UIButton.init(type: .custom)
        chapterList.setImage(UIImage.init(named: "bar_chapter_list")?.template, for: .normal)
        chapterList.addTarget(self, action: #selector(didClickChapterListButton), for: .touchUpInside)
        self.addSubview(chapterList)
        chapterList.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(itemHeight)
            make.bottom.equalTo(self)
            make.left.equalTo(backButton.snp.right)
        }
        
        bookmark = UIButton.init(type: .custom)
        bookmark.setImage(UIImage.init(named: "read_setting_bookmark")?.template, for: .normal)
        bookmark.setImage(UIImage.init(named: "bookmark"), for: .selected)
        bookmark.addTarget(self, action: #selector(didClickBookmarkButton), for: .touchUpInside)
        self.addSubview(bookmark)
        bookmark.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(itemHeight)
            make.bottom.equalTo(self)
            make.right.equalTo(self).offset(-10)
        }
        
        readSetting = UIButton.init(type: .custom)
        readSetting.setImage(UIImage.init(named: "setting")?.template, for: .normal)
        readSetting.addTarget(self, action: #selector(didClickReadSettingButton), for: .touchUpInside)
        self.addSubview(readSetting)
        readSetting.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(itemHeight)
            make.bottom.equalTo(self)
            make.right.equalTo(bookmark.snp.left)
        }
        
        bottomLine = UIView()
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        self.updateThemeColor()
    }
    
    func updateThemeColor() {
        
        self.backgroundColor = IRReaderConfig.pageColor
        bottomLine.backgroundColor = IRReaderConfig.textColor.withAlphaComponent(0.08)
        self.tintColor = IRReaderConfig.textColor
    }
    
    //MARK: - Action
    
    @objc func didClickBackButton() {
        self.delegate?.readNavigationBar(didClickBack: self)
    }
    
    @objc func didClickChapterListButton() {
        self.delegate?.readNavigationBar(didClickChapterList: self)
    }
    
    @objc func didClickReadSettingButton() {
        self.delegate?.readNavigationBar(didClickReadSetting: self)
    }
    
    @objc func didClickBookmarkButton() {
        bookmark.isSelected = !bookmark.isSelected
        self.delegate?.readNavigationBar(self, didSelectBookmark: bookmark.isSelected)
    }
}
