//
//  IRReadPageViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/10.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import DTCoreText

class IRReadPageViewController: UIViewController {

    private var pageSize = CGSize.zero
    var pageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var contentLabel: DTAttributedLabel = {
        let label = DTAttributedLabel()
        label.backgroundColor = UIColor.clear
        return label
    }()

    var pageModel: IRBookPage? {
        willSet {
            self.contentLabel.attributedString = newValue?.content
            if let displayPageIdx = newValue?.displayPageIdx {
                self.pageLabel.text = String(displayPageIdx)
            } else {
                self.pageLabel.text = ""
            }
        }
    }
    
    convenience init(withPageSize pageSize: CGSize) {
        self.init()
        self.pageSize = pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateThemeColor()
        self.view.addSubview(contentLabel)
        self.view.addSubview(pageLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if pageModel?.textColorHex != IRReaderConfig.textColorHex {
            pageModel?.textColorHex = IRReaderConfig.textColorHex
            pageModel?.updateTextColor(IRReaderConfig.textColor)
            self.contentLabel.attributedString = pageModel?.content
        }
        self.view.backgroundColor = IRReaderConfig.pageColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let pageX = (self.view.width - pageSize.width) / 2.0
        let pageY = (self.view.height - pageSize.height) / 2.0
        contentLabel.frame = CGRect.init(origin: CGPoint.init(x: pageX, y: pageY), size: pageSize)
        
        pageLabel.frame = CGRect.init(x: 0, y: contentLabel.frame.maxY + IRReaderConfig.pageIndexSpacing, width: self.view.width, height: 12)
    }
    
    func updateThemeColor() {
        self.view.backgroundColor = IRReaderConfig.pageColor
        pageLabel.textColor = IRReaderConfig.textColor
    }
}
