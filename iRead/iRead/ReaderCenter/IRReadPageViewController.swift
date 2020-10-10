//
//  IRReadPageViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/10.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRReadPageViewController: UIViewController {

    private var pageSize = CGSize.zero
    
    private var pageLabel: DTAttributedLabel = {
        let pageLabel = DTAttributedLabel()
        pageLabel.backgroundColor = UIColor.clear;
        return pageLabel
    }()

    var bookPage: IRBookPage? {
        willSet {
            self.pageLabel.attributedString = newValue?.content
        }
    }
    
    convenience init(withPageSize pageSize: CGSize) {
        self.init()
        self.pageSize = pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(pageLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let pageX = (self.view.width - pageSize.width) / 2.0
        let pageY = (self.view.height - pageSize.height) / 2.0
        pageLabel.frame = CGRect.init(origin: CGPoint.init(x: pageX, y: pageY), size: pageSize)
    }
}
