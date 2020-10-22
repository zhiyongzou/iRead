//
//  IRFontSelectCell.swift
//  iRead
//
//  Created by zzyong on 2020/10/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRFontSelectCell: UICollectionViewCell {
    
    static let cellHeight: CGFloat = 45
    var selectView: UIImageView?
    var downloadView: UIImageView?
    var titleLabel = UILabel()
    var separatorLine = UIView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                self.contentView.backgroundColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 0.5)
            } else {
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.addSelectViewIfNeeded()
            }
            selectView?.isHidden = !newValue
        }
    }
    
    var fontModel: IRFontModel? {
        willSet {
            guard let font = newValue else { return }
            
            if self.isSelected {
                self.addSelectViewIfNeeded()
            }
            selectView?.isHidden = !self.isSelected
            
            if font.isDownload {
                titleLabel.font = UIFont.init(name: font.fontName, size: 20)
            } else {
                self.addDownloadViewIfNeeded()
                titleLabel.font = UIFont.systemFont(ofSize: 20)
            }
            downloadView?.isHidden = font.isDownload
            titleLabel.text = font.dispalyName
            
            titleLabel.textColor = IRReaderConfig.textColor
            separatorLine.backgroundColor = IRReaderConfig.separatorColor
            contentView.tintColor = IRReaderConfig.textColor
        }
    }
    
    func addSelectViewIfNeeded() {
        if selectView != nil {
            return
        }
        
        selectView = UIImageView.init(image: UIImage.init(named: "font_select")?.withRenderingMode(.alwaysTemplate))
        selectView?.contentMode = .scaleAspectFit
        self.contentView.addSubview(selectView!)
        selectView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(16)
            make.height.equalTo(11.2)
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(15)
        }
    }
    
    func addDownloadViewIfNeeded() {
        if downloadView != nil {
            return
        }
        
        downloadView = UIImageView.init(image: UIImage.init(named: "font_download")?.withRenderingMode(.alwaysTemplate))
        self.contentView.addSubview(downloadView!)
        downloadView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(17)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-20)
        }
    }
    
    private func setupSubviews() {
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(40)
        }
        
        self.contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
