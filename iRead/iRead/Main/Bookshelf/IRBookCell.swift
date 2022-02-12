//
//  IRBookCell.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import CommonLib
import IRHexColor

/// 书封面比例(width/height)
public let bookCoverScale: CGFloat = 0.72
/// 底部容器高度
private let bookCellBottomHeight: CGFloat = 40

protocol IRBookCellDelegate: AnyObject {
    func bookCellDidClickOptionButton(_ cell: IRBookCell)
}

class IRBookCell: UICollectionViewCell {
    
    enum CellStyle: Int {
        case Square
        case Row
    }
    
    let pogressH: CGFloat = 18
    var bookCoverView = UIImageView()
    var bookCoverShadow = UIView()
    var progressLabel = UILabel()
    var style = CellStyle.Square
    var optionButton = UIButton.init(type: .custom)
    
    weak var delegate: IRBookCellDelegate?
    
    var authorLabel: UILabel?
    var bookNameLabel: UILabel?
    var bottomLine: UIView?
    
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
        
        if style == .Square {
            updateSquareCellLayout()
        } else {
            updateRowCellLayout()
        }
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
        bookCoverView.contentMode = .scaleAspectFit
        bookCoverView.layer.cornerRadius = cornerRadius
        contentView.addSubview(bookCoverView)

        progressLabel.layer.cornerRadius = pogressH * 0.5
        progressLabel.layer.masksToBounds = true
        progressLabel.font = UIFont.systemFont(ofSize: 12)
        progressLabel.textAlignment = .left
        contentView.addSubview(progressLabel)
        
        optionButton.setImage(UIImage.init(named: "more_icon"), for: .normal)
        optionButton.contentHorizontalAlignment = .right
        optionButton.touchPointOffset = 10
        optionButton.addTarget(self, action: #selector(didClickOptionButton(_:)), for: .touchUpInside)
        contentView.addSubview(optionButton)
    }
    
    @objc func didClickOptionButton(_ button: UIButton) {
        self.delegate?.bookCellDidClickOptionButton(self)
    }
    
    func updateProgressLabelText() {
        var textColor: UIColor?
        var bgColor: UIColor?
        var textAlignment: NSTextAlignment?
        if let progress = bookModel?.progress {
            if progress <= 0 {
                progressLabel.text = "新增"
                bgColor = UIColor.rgba(255, 156, 0, 1)
                textAlignment = .center
                textColor = .white
            } else if progress >= 100 {
                progressLabel.text = "已读完"
            } else {
                progressLabel.text = "\(progress)%"
            }
        } else {
            progressLabel.text = ""
        }
        progressLabel.textColor = textColor ?? UIColor.hexColor("666666")
        progressLabel.textAlignment = textAlignment ?? .left
        progressLabel.backgroundColor = bgColor ?? UIColor.clear
    }
    
    // MARK: - Public
    
    public class func cellHeightWithWidth(_ width: CGFloat) -> CGFloat {
        return width / bookCoverScale + bookCellBottomHeight
    }
    
    public var bookModel: IRBookModel? {
        didSet {
            bookCoverView.image = bookModel?.coverImage
            self.updateProgressLabelText()
            let isRowStyle = style == .Row
            if isRowStyle {
                addRowCellSubviewsIfNeeded()
                bookNameLabel?.text = bookModel?.bookName
                authorLabel?.text = bookModel?.authorName
            }
            bookNameLabel?.isHidden = !isRowStyle
            authorLabel?.isHidden = !isRowStyle
            bottomLine?.isHidden = !isRowStyle
            bookCoverShadow.isHidden = isRowStyle
        }
    }
}

// MARK: Square Cell

extension IRBookCell {
    
    func updateSquareCellLayout() {
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
        
        let progressY = bookCoverView.frame.maxY + (bookCellBottomHeight - pogressH) * 0.5
        let progressW = ((progressLabel.text ?? "") as NSString).size(withAttributes: [.font: progressLabel.font!]).width + 12
        progressLabel.frame = CGRect(x: 0, y: progressY, width: progressW, height: pogressH)
        let optionBtnW: CGFloat = 30
        optionButton.frame = CGRect(x: self.width - optionBtnW, y: progressY, width: optionBtnW, height: bookCellBottomHeight)
    }
}

// MARK: Row Cell

extension IRBookCell {
    
    func updateRowCellLayout() {

        let spacing: CGFloat = 15
        let contentW = contentView.width - spacing
        bookCoverView.frame = CGRect(x: spacing, y: 0, width: 50, height: contentView.height)
        
        let authorX = bookCoverView.frame.maxX + 10
        let authorH: CGFloat = 18
        let authorY = (contentView.height - authorH) / 2.0
        let authorW = contentW - authorX
        authorLabel?.frame = CGRect(x: authorX, y: authorY, width: authorW, height: authorH)
        
        let bookNameH: CGFloat = 20
        let bookNameY = authorY - bookNameH - 5
        bookNameLabel?.frame = CGRect(x: authorX, y: bookNameY, width: authorW, height: bookNameH)
        
        let progressY = authorY + authorH + 5
        let progressW = ((progressLabel.text ?? "") as NSString).size(withAttributes: [.font: progressLabel.font!]).width + 12
        progressLabel.frame = CGRect(x: authorX, y: progressY, width: progressW, height: pogressH)
        
        let optionSize: CGFloat = pogressH
        optionButton.frame = CGRect(x: contentW - optionSize, y: progressY, width: optionSize, height: optionSize)
         
        bottomLine?.frame = CGRect(x: spacing, y: contentView.height - 0.5, width: contentW - spacing, height: 0.5)
    }
    
    func addRowCellSubviewsIfNeeded() {
        
        if authorLabel == nil {
            authorLabel = UILabel()
            authorLabel!.font = .systemFont(ofSize: 12)
            authorLabel!.textColor = .hexColor("999999")
            contentView.addSubview(authorLabel!)
        }
        
        if bookNameLabel == nil {
            bookNameLabel = UILabel()
            bookNameLabel!.font = .systemFont(ofSize: 15)
            bookNameLabel!.textColor = .hexColor("333333")
            contentView.addSubview(bookNameLabel!)
        }
        
        if bottomLine == nil {
            bottomLine = UIView()
            bottomLine!.backgroundColor = .hexColor("e0e0e0")
            contentView.addSubview(bottomLine!)
        }
    }
}
