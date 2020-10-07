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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookCoverView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bookCoverView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.width / bookCoverScale)
        
        let progressY = self.bookCoverView.frame.maxY
        self.progressLabel.frame = CGRect.init(x: 0, y: progressY, width: 60, height: bookCellBottomHeight)
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        
        self.contentView.backgroundColor = UIColor.white
        
        bookCoverView = UIImageView()
        bookCoverView.contentMode = .scaleAspectFit
#if DEBUG
        bookCoverView.layer.borderWidth = 1
        bookCoverView.layer.borderColor = UIColor.randomColor().cgColor
#endif
        self.contentView.addSubview(bookCoverView)
        
        progressLabel = UILabel()
        progressLabel.text = "\(arc4random()%99)%"
        progressLabel.textColor = UIColor.hexColor("666666")
        progressLabel.font = UIFont.systemFont(ofSize: 13)
        progressLabel.textAlignment = .left
        self.contentView.addSubview(progressLabel)
    }
    
    // MARK: - Public
    
    public class func cellHeightWithWidth(_ width: CGFloat) -> CGFloat {
        return width / bookCoverScale + bookCellBottomHeight
    }
    
    public var bookModel: FRBook? {
        willSet {
            if let coverUrl = newValue?.coverImage?.fullHref {
                bookCoverView.image = UIImage.init(contentsOfFile: coverUrl)
            }
        }
    }
}
