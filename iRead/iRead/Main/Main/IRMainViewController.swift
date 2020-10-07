//
//  IRMainViewController.swift
//  iRead
//
//  Created by zzyong on 2020/9/24.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

enum IRTabIndex: Int {
    case home = 0
    case mine = 1
}

class IRMainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    override var selectedIndex: Int {
        willSet {
            self.updateNavigationItems(withIndex: newValue)
        }
    }
    
    // MARK: - Private
    
    func commonInit() {
        self.delegate = self
        self.setupTabbarItems()
    }
    
    func setupTabbarItems() {
        self.tabBar.tintColor = IRAppThemeColor
        
        let tabbarTitles = ["首页", "我的"]
        var childViewControllers = [UIViewController]()
        
        for (index, _) in tabbarTitles.enumerated() {
            childViewControllers.append(self.childViewController(withTabIndex: index))
        }
        self.viewControllers = childViewControllers
        
        for (index, item) in self.tabBar.items!.enumerated() {
            var normalName: String?, selectName: String?
            switch index {
            case IRTabIndex.home.rawValue:
                normalName = "tabbar_home_n"; selectName = "tabbar_home_s"
            case IRTabIndex.mine.rawValue:
                normalName = "tabbar_mine_n"; selectName = "tabbar_mine_s"
            default:
                IRDebugLog("TabIndex: (\(index)) undefine")
            }
            item.title = tabbarTitles[index]
            if let normalName = normalName, let selectName = selectName {
                item.image = UIImage.init(named: normalName)?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage.init(named: selectName)?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    func childViewController(withTabIndex index: Int) -> UIViewController {
        var vc: UIViewController
        switch index {
        case IRTabIndex.home.rawValue:
            vc = IRHomeViewController()
        case IRTabIndex.mine.rawValue:
            vc = IRMineViewController()
        default:
            vc = UIViewController()
        }
        return vc
    }
    
    func updateNavigationItems(withIndex index: Int) {
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        
        switch index {
        case IRTabIndex.home.rawValue:
            self.navigationItem.title = self.selectedViewController?.navigationItem.title
        case IRTabIndex.mine.rawValue:
            self.navigationItem.title = self.selectedViewController?.navigationItem.title
        default:
            IRDebugLog("TabIndex: (\(index)) undefine")
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         IRDebugLog("TabIndex: (\(item)) undefine")
    }
}
