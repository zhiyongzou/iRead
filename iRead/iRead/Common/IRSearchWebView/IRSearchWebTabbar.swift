//
//  IRSearchWebTabbar.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchWebTabbar: UIView {
    
    weak var delegate: IRSearchWebTabbarDelegate?

    lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isEnabled = false
        button.setImage(UIImage(named: "web_arrow"), for: .normal)
        button.setImage(UIImage(named: "web_arrow_h"), for: .highlighted)
        button.setImage(UIImage(named: "web_arrow_d"), for: .disabled)
        button.addTarget(self, action: #selector(didClickBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var forwardButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isEnabled = false
        button.transform = CGAffineTransform.init(rotationAngle: .pi)
        button.setImage(UIImage(named: "web_arrow"), for: .normal)
        button.setImage(UIImage(named: "web_arrow_h"), for: .highlighted)
        button.setImage(UIImage(named: "web_arrow_d"), for: .disabled)
        button.addTarget(self, action: #selector(didClickForwardButton), for: .touchUpInside)
        return button
    }()
    
    lazy var reloadButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "web_reload"), for: .normal)
        button.setImage(UIImage(named: "web_reload_h"), for: .highlighted)
        button.addTarget(self, action: #selector(didClickReloadButton), for: .touchUpInside)
        return button
    }()
    
    lazy var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect.init(style: .extraLight)
        let effectView = UIVisualEffectView.init(effect: blur)
        return effectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(effectView)
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(reloadButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        effectView.frame = bounds
        
        let margin = 8.0
        var safeBottom = 0.0
        if #available(iOS 11.0, *) {
            safeBottom = self.safeAreaInsets.bottom
        }
        let height = self.height - safeBottom
        
        backButton.frame = CGRect(x: margin, y: 0, width: height, height: height)
        forwardButton.frame = CGRect(x: margin * 3 + backButton.frame.maxX, y: 0, width: height, height: height)
        reloadButton.frame = CGRect(x: self.width - margin - height, y: 0, width: height, height: height)
    }
    
    //MARK: Actions
    
    @objc func didClickBackButton() {
        delegate?.searchWebTabbarDidClickBackButton?(self)
    }
    
    @objc func didClickForwardButton() {
        delegate?.searchWebTabbarDidClickForwardButton?(self)
    }
    
    @objc func didClickReloadButton() {
        delegate?.searchWebTabbarDidClickReloadButton?(self)
    }
    
}
