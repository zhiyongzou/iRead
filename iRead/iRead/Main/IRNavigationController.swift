//
//  IRNavigationController.swift
//  iRead
//
//  Created by zzyong on 2020/2/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRNavigationController: UINavigationController {

    public static weak var bookshelfViewController: IRBookshelfViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 解决 UINavigationController pushViewController 时导航栏黑影问题
        view.backgroundColor = .white
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewController.isKind(of: IRBookshelfViewController.self) {
            IRNavigationController.bookshelfViewController = viewController as? IRBookshelfViewController
        }
        return super.pushViewController(viewController, animated: animated)
    }
}
