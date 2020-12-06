//
//  IRBookCell.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib
import IRHexColor

/// 书封面比例(width/height)
let bookCoverScale: CGFloat = 0.72
/// 底部容器高度
private let bookCellBottomHeight: CGFloat = 40

class IRBookCell: UICollectionViewCell {
    
    var bookCoverView: UIImageView!
    var progressLabel: UILabel!
    var optionButton: UIButton!
    
    // MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookCoverView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var coverH: CGFloat = 0
        var coverW: CGFloat = 0
        if let coverImg = bookCoverView.image {
            let imageScale = coverImg.size.width / coverImg.size.height
            if imageScale <= bookCoverScale {
                coverH = self.width / bookCoverScale
                coverW = coverH * imageScale
            } else {
                coverW = self.width
                coverH = coverW / imageScale
            }
        } else {
            coverH = self.width / bookCoverScale
            coverW = self.width
        }
        let coverX: CGFloat = (self.width - coverW) * 0.5
        let coverY: CGFloat = self.height - coverH - bookCellBottomHeight
        bookCoverView.frame = CGRect.init(x: coverX, y: coverY, width: coverW, height: coverH)
        
        let progressY = bookCoverView.frame.maxY
        progressLabel.frame = CGRect.init(x: 0, y: progressY, width: 60, height: bookCellBottomHeight)
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        
        contentView.backgroundColor = .white
        
        bookCoverView = UIImageView()
        bookCoverView.contentMode = .scaleAspectFit
        contentView.addSubview(bookCoverView)

        progressLabel = UILabel()
        progressLabel.text = "\(arc4random()%99)%"
        progressLabel.textColor = UIColor.hexColor("666666")
        progressLabel.font = UIFont.systemFont(ofSize: 13)
        progressLabel.textAlignment = .left
        contentView.addSubview(progressLabel)
    }
    
    // MARK: - Public
    
    public class func cellHeightWithWidth(_ width: CGFloat) -> CGFloat {
        return width / bookCoverScale + bookCellBottomHeight
    }
    
    public var bookModel: IRBook? {
        willSet {
            bookCoverView.image = newValue?.coverImage
        }
    }
}
