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

protocol IRBookCellDelegate: AnyObject {
    func bookCellDidClickOptionButton(_ cell: IRBookCell)
}

class IRBookCell: UICollectionViewCell {
    
    var bookCoverView = UIImageView()
    var bookCoverShadow = UIView()
    var progressLabel = UILabel()
    var optionButton = UIButton.init(type: .custom)
    
    weak var delegate: IRBookCellDelegate?
    
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
        bookCoverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        bookCoverShadow.frame = bookCoverView.frame
        
        let progressY = bookCoverView.frame.maxY
        progressLabel.frame = CGRect(x: 0, y: progressY, width: 60, height: bookCellBottomHeight)
        let optionBtnW: CGFloat = 30
        optionButton.frame = CGRect(x: self.width - optionBtnW, y: progressY, width: optionBtnW, height: bookCellBottomHeight)
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        
        contentView.backgroundColor = .white
        
        // https://stackoverflow.com/questions/3690972/why-maskstobounds-yes-prevents-calayer-shadow
        let cornerRadius: CGFloat = 3
        bookCoverShadow.backgroundColor = .white
        bookCoverShadow.layer.cornerRadius = cornerRadius
        bookCoverShadow.layer.shadowOpacity = 0.25
        bookCoverShadow.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        contentView.addSubview(bookCoverShadow)
        
        bookCoverView.layer.masksToBounds = true
        bookCoverView.layer.cornerRadius = cornerRadius
        contentView.addSubview(bookCoverView)

        progressLabel.text = "\(arc4random()%99)%"
        progressLabel.textColor = UIColor.hexColor("666666")
        progressLabel.font = UIFont.systemFont(ofSize: 13)
        progressLabel.textAlignment = .left
        contentView.addSubview(progressLabel)
        
        optionButton.setImage(UIImage.init(named: "more_icon"), for: .normal)
        optionButton.contentHorizontalAlignment = .right
        optionButton.addTarget(self, action: #selector(didClickOptionButton(_:)), for: .touchUpInside)
        contentView.addSubview(optionButton)
    }
    
    @objc func didClickOptionButton(_ button: UIButton) {
        self.delegate?.bookCellDidClickOptionButton(self)
    }
    
    // MARK: - Public
    
    public class func cellHeightWithWidth(_ width: CGFloat) -> CGFloat {
        return width / bookCoverScale + bookCellBottomHeight
    }
    
    public var bookModel: IRBookModel? {
        willSet {
            bookCoverView.image = newValue?.coverImage
        }
    }
}
