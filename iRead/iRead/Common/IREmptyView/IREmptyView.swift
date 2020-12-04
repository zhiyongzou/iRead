//
//  IREmptyView.swift
//  iRead
//
//  Created by zzyong on 2020/12/4.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import SnapKit

class IREmptyView: UIView {
    
    lazy var emptyIcon = UIImageView()
    lazy var titleLabel = UILabel()
    var subLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    private func setupSubviews() {
        self.backgroundColor = UIColor.clear
        
        emptyIcon.image = UIImage.init(named: "empty_icon")
        self.addSubview(emptyIcon)
        emptyIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 59, height: 49))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-20)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = IRReaderConfig.textColor
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(emptyIcon.snp.bottom).offset(11)
            make.centerX.equalTo(self)
        }
    }
    
    private func addSubLabelIfNeeded() {
        if subLabel != nil {
            return
        }
        
        subLabel = UILabel()
        subLabel!.numberOfLines = 2
        subLabel!.textColor = IRReaderConfig.textColor.withAlphaComponent(0.5)
        subLabel!.textAlignment = .center
        subLabel!.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(subLabel!)
        subLabel!.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.centerX.equalTo(self)
        }
    }
    
    //MARK: - Public
    func setTitle(_ title: String?, subTitle: String?) {
        titleLabel.text = title
        if let subTitle = subTitle {
            self.addSubLabelIfNeeded()
            subLabel?.text = subTitle
        }
    }
}
