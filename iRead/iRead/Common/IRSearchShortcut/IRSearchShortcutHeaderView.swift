//
//  IRSearchShortcutHeaderView.swift
//  iRead
//
//  Created by zzyong on 2022/1/26.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutHeaderView: UICollectionReusableView {
    
    var margin: CGFloat = 0.0
    
    lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = .black
        titleLable.font = UIFont.boldSystemFont(ofSize: 15)
        titleLable.textAlignment = .left
        return titleLable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLable.frame = CGRect(x: margin, y: 0, width: self.width - margin * 2, height: self.height)
    }
    
    /// 更新标题和边距
    /// - Parameters:
    ///   - title: 标题
    ///   - margin: 边距
    func update(_ title: String?, margin: CGFloat) {
        titleLable.text = title
        self.margin = margin
        setNeedsLayout()
    }
    
}
