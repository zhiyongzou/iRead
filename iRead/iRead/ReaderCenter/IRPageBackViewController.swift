//
//  IRPageBackViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/13.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRPageBackViewController: UIViewController {

    var contentView: UIView?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView?.frame = self.view.bounds
    }
    
    class func pageBackViewController(WithPageView content: UIView?) -> IRPageBackViewController {
        
        let backVc = IRPageBackViewController()

        guard let snap = content?.snapshotView(afterScreenUpdates: true) else {
            return backVc
        }
        
        snap.transform = CGAffineTransform.init(a: -1, b: 0, c: 0, d: 1, tx: snap.frame.size.width, ty: 0)
        backVc.contentView = snap;
        backVc.view.addSubview(snap)
        
        return backVc
    }
}
