//
//  AppDelegate+Debug.swift
//  iRead
//
//  Created by zzyong on 2021/12/5.
//  Copyright © 2021 iread.com. All rights reserved.
//

#if DEBUG

import FLEX
import UIKit

public let flexWindow: UIWindow = UIWindow()

extension AppDelegate {
    
    func setupDebugConfig() {
        addFlexDebugView()
    }
    
    func addFlexDebugView() {
        
        flexWindow.backgroundColor = .clear
        flexWindow.rootViewController = .init()
        flexWindow.windowLevel = UIWindow.Level.statusBar + 50;
        
        let flexY = UIApplication.shared.statusBarFrame.maxY
        let flexW: CGFloat = 30
        let flexX = (UIScreen.main.bounds.width - flexW) * 0.5
        flexWindow.frame = CGRect.init(x: flexX, y: flexY, width: flexW, height: 13)
        
        flexWindow.makeKeyAndVisible()
        
        let flexBtn: UIButton = .init(type: UIButton.ButtonType.custom)
        flexBtn.titleLabel?.font = .systemFont(ofSize: 12);
        flexBtn.setTitle("FLEX", for: UIControl.State.normal)
        flexBtn.setTitleColor(.blue, for: UIControl.State.normal)
        flexBtn.addTarget(self, action:#selector(AppDelegate.showFlexDebugView), for: UIControl.Event.touchUpInside)
        flexBtn.frame = flexWindow.bounds
        flexWindow.addSubview(flexBtn)
        flexWindow.isHidden = !UserDefaults.standard.bool(forKey: kEnableFlex)
    }
    
    @objc func showFlexDebugView() {
        FLEXManager.shared.showExplorer()
    }
}

#endif
