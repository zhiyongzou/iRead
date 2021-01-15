//
//  IRHomeCurrentReadingCell.swift
//  iRead
//
//  Created by zzyong on 2020/12/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit

class IRHomeCurrentReadingCell: UICollectionViewCell {
    
    static let cellHeight: CGFloat = 225.5
    var bookContentView: UIView?
    var bookCover: UIImageView?
    var bookNameLabel: UILabel?
    var authorLabel: UILabel?
    var progressLabel: UILabel?
    var emptyLabel: UILabel?
    var titleLabel = UILabel()
    var readingBtn = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var readingModel: IRHomeCurrentReadingModel? {
        didSet {
            if let isReading = readingModel?.isReading, isReading {
                addBookContentViewIfNeeded()
                emptyLabel?.isHidden = true
                bookContentView?.isHidden = false
                readingBtn.setTitle("继续阅读", for: .normal)
                
                bookCover?.image = readingModel?.coverImage
                bookNameLabel?.text = readingModel?.bookName
                authorLabel?.text = readingModel?.author
                
                var progressText: String?
                if let progress = readingModel?.progress {
                    progressText = progress > 0 ? "\(progress)%" : "新增"
                }
                progressLabel?.text = progressText
            } else {
                addEmptyLabelIfNeeded()
                bookContentView?.isHidden = true
                emptyLabel?.isHidden = false
                readingBtn.setTitle("添加图书", for: .normal)
            }
        }
    }
    
    func addEmptyLabelIfNeeded() {
        if emptyLabel != nil {
            return
        }
        let emptyLabel = UILabel()
        self.emptyLabel = emptyLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.textColor = .hexColor("666666")
        emptyLabel.text = "您暂无正在阅读的图书，快去添加一本好书看看吧～"
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(readingBtn.snp.top).offset(-20)
        }
    }
    
    func addBookContentViewIfNeeded() {
        if bookContentView != nil {
            return
        }
        
        let bookContentH: CGFloat = 83.5
        bookContentView = UIView()
        addSubview(bookContentView!)
        bookContentView!.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(bookContentH)
        }
        
        let bookCover = UIImageView()
        self.bookCover = bookCover
        bookCover.contentMode = .scaleAspectFit
        bookCover.backgroundColor = .hexColor("EEEEEE")
        bookCover.layer.cornerRadius = 3
        bookCover.layer.masksToBounds = true
        bookContentView!.addSubview(bookCover)
        bookCover.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(bookContentView!)
            make.width.equalTo(60)
        }
        
        let authorLabel = UILabel()
        self.authorLabel = authorLabel
        authorLabel.font = .systemFont(ofSize: 15)
        authorLabel.textColor = .hexColor("333333")
        bookContentView!.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bookContentView!)
            make.left.equalTo(bookCover.snp.right).offset(10)
        }
        
        let titleLabel = UILabel()
        self.bookNameLabel = titleLabel
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        bookContentView!.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(authorLabel.snp.top).offset(-6)
            make.left.equalTo(authorLabel)
        }
        
        let progressLabel = UILabel()
        self.progressLabel = progressLabel
        progressLabel.font = .systemFont(ofSize: 15)
        progressLabel.textColor = .hexColor("999999")
        bookContentView!.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(authorLabel.snp.bottom).offset(6)
            make.left.equalTo(authorLabel)
        }
    }
    
    func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        titleLabel.textColor = .hexColor("666666")
        titleLabel.text = "当前阅读"
        titleLabel.font = .systemFont(ofSize: 16)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.top.left.equalTo(self).offset(20)
        }
        
        let readingBtnH: CGFloat = 44
        readingBtn.addTarget(self, action: #selector(didClickReadingButton), for: .touchUpInside)
        readingBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        readingBtn.backgroundColor = .black
        readingBtn.layer.cornerRadius = readingBtnH / 2
        addSubview(readingBtn)
        readingBtn.snp.makeConstraints { (make) in
            make.height.equalTo(readingBtnH)
            make.bottom.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    @objc func didClickReadingButton() {
        
    }
}
