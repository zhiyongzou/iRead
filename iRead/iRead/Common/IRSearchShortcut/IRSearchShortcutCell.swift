//
//  IRSearchShortcutCell.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutCell: UICollectionViewCell {
    
    static var cellHeight = 30.0
    static var titleFont = UIFont.systemFont(ofSize: 13)
    
    lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.font = IRSearchShortcutCell.titleFont
        titleLable.textAlignment = .center
        titleLable.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        titleLable.layer.cornerRadius = IRSearchShortcutCell.cellHeight * 0.5
        titleLable.layer.masksToBounds = true
        return titleLable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleLableY = max(0, (contentView.height - IRSearchShortcutCell.cellHeight) * 0.5)
        titleLable.frame = CGRect(x: 0, y: titleLableY, width: contentView.width, height: IRSearchShortcutCell.cellHeight)
    }
    
    var title: String? {
        didSet {
            titleLable.text = title
        }
    }
    
}
