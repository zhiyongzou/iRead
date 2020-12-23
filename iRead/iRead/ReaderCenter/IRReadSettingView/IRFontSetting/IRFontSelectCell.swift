//
//  IRFontSelectCell.swift
//  iRead
//
//  Created by zzyong on 2020/10/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRFontSelectCell: UICollectionViewCell, IRFontDownloadDelegate {
    
    static let cellHeight: CGFloat = 46
    var fontDownload: IRFontDownload?
    var selectView: UIImageView?
    var downloadBtn: UIButton?
    var titleLabel = UILabel()
    var separatorLine = UIView()
    var progressLabel: UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    deinit {
        fontDownload?.stop = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fontDownload?.stop = true
    }
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                contentView.backgroundColor = UIColor.rgba(200, 200, 200, 0.5)
            } else {
                contentView.backgroundColor = UIColor.clear
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
            downloadBtn?.isHidden = font.isDownload
            titleLabel.text = font.dispalyName
            
            progressLabel?.textColor = IRReaderConfig.textColor
            titleLabel.textColor = IRReaderConfig.textColor
            separatorLine.backgroundColor = IRReaderConfig.separatorColor
            contentView.tintColor = IRReaderConfig.textColor
        }
    }
    
    func addSelectViewIfNeeded() {
        if selectView != nil {
            return
        }
        
        selectView = UIImageView.init(image: UIImage.init(named: "font_select")?.template)
        selectView?.contentMode = .scaleAspectFit
        contentView.addSubview(selectView!)
        selectView!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(16)
            make.height.equalTo(11.2)
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
        }
    }
    
    func addDownloadViewIfNeeded() {
        if downloadBtn != nil {
            return
        }
        
        downloadBtn = UIButton.init(type: .custom)
        downloadBtn?.setImage(UIImage.init(named: "font_download")?.template, for: .normal)
        downloadBtn?.addTarget(self, action: #selector(didClickDownloadButton), for: .touchUpInside)
        contentView.addSubview(downloadBtn!)
        downloadBtn!.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(contentView.snp.height)
            make.height.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
        }
    }
    
    func addProgressLabelIfNeeded() {
        
        if progressLabel != nil {
            return
        }
        
        progressLabel = UILabel()
        progressLabel!.textAlignment = .left
        progressLabel!.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(progressLabel!)
        progressLabel!.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
        }
    }
    
    private func setupSubviews() {
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(contentView).offset(40)
        }
        
        contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel)
            make.right.equalTo(contentView)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    //MARK: - Actions
    
    @objc func didClickDownloadButton() {
        if fontDownload == nil {
            fontDownload = IRFontDownload()
            fontDownload?.delegate = self
        }
        fontDownload?.begin = true
        fontDownload?.downloadFontWithName(self.fontModel!.fontName)
    }
    
    //MARK: - IRFontDownloadDelegate
    
    func fontDownloadDidBegin(_ downloader: IRFontDownload) {
        self.addProgressLabelIfNeeded()
        self.progressLabel?.isHidden = false
        self.downloadBtn?.isHidden = true
    }
    
    func fontDownloadDidFinish(_ downloader: IRFontDownload) {
        progressLabel?.isHidden = true
        fontModel?.isDownload = true
        titleLabel.font = UIFont.init(name: fontModel!.fontName, size: 20)
        UserDefaults.standard.set(true, forKey: fontModel!.fontName)
    }
    
    func fontDownloadDidFail(_ downloader: IRFontDownload, error: Error?) {
        downloadBtn?.isHidden = false
        progressLabel?.isHidden = true
    }
    
    func fontDownloadDownloading(_ downloader: IRFontDownload, progress: Double) {
        progressLabel?.text = "\(progress / 100)%"
    }
}
