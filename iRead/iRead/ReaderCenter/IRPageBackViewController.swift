//
//  IRPageBackViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/13.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRPageBackViewController: UIViewController {

    var contentImgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentImgView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentImgView.frame = self.view.bounds
    }
    
    class func pageBackViewController(WithPageView content: UIView?) -> IRPageBackViewController {
        
        let backVc = IRPageBackViewController()
        guard let content = content else { return backVc }
        
        UIGraphicsBeginImageContext(content.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return backVc
        }
        let transform = CGAffineTransform.init(a: -1, b: 0, c: 0, d: 1, tx: content.frame.size.width, ty: 0)
        context.concatenate(transform);
        content.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        backVc.contentImgView.image = image
        UIGraphicsEndImageContext()
        
        return backVc
    }
}
