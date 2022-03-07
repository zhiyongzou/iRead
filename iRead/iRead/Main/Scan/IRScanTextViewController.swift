//
//  IRScanTextViewController.swift
//  iRead
//
//  Created by zzyong on 2022/2/19.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import CommonLib

class IRScanTextViewController: IRBaseViewcontroller {
    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .init(white: 0.95, alpha: 1)
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.textColor = .black
        return textView
    }()
    
    var scanText: String? {
        didSet {
            textView.text = scanText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "文本信息"
        setupLeftBackBarItem()
        view.addSubview(textView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let spacing = 10.0
        var textY = spacing
        if let navMaxY = navigationController?.navigationBar.frame.maxY {
            textY = textY + navMaxY
        }
        textView.frame = CGRect(x: spacing, y: textY, width: view.width - spacing * 2, height: view.height * 0.25)
    }
}
