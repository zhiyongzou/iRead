//
//  IRArrowSettingView.swift
//  iRead
//
//  Created by zzyong on 2020/10/14.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRHexColor

class IRArrowSettingView: UIView {

    static let viewHeight: CGFloat = 40

    var titleLabel = UILabel()
    var arrowView = UIImageView()
    var detailLabel: UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.clear
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.clear
    }
    
    func addDdetailLabelIfNeeded() {
        if detailLabel != nil {
            return
        }
        
        detailLabel = UILabel()
        detailLabel?.textAlignment = .right
        detailLabel?.font = UIFont.systemFont(ofSize: 15)
        detailLabel?.textColor = UIColor.hexColor("666666")
        self.addSubview(detailLabel!)
        detailLabel?.snp.makeConstraints { (make) in
            make.right.equalTo(arrowView.snp.left).offset(-3)
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(self)
        }
    }
    
    func setupSubviews() {
        
        let margin: CGFloat = 15
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(margin)
            make.centerY.equalTo(self)
        }
        
        arrowView.image = UIImage.init(named: "arrow_grey_right")
        self.addSubview(arrowView)
        arrowView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(self).offset(-margin)
            make.centerY.equalTo(self)
        }
    }
    
    var detailText: String? {
        willSet {
            if newValue != nil {
                self.addDdetailLabelIfNeeded()
            }
            detailLabel?.text = newValue
        }
    }
}