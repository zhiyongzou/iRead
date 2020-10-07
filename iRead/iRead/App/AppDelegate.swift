//
//  AppDelegate.swift
//  iRead
//
//  Created by zzyong on 2020/2/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

#if DEBUG
    lazy var flexWindow: UIWindow = UIWindow()
#endif
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
#if DEBUG
        setupDebugConfig()
#endif
        self.setupMainViewController()
        
        return true
    }
    
    func setupMainViewController() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let mainVC = IRMainViewController()
        let rootVC = IRNavigationController.init(rootViewController: mainVC)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

#if DEBUG

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
    }
    
    @objc func showFlexDebugView() {
        FLEXManager.shared.showExplorer()
    }
}

#endif
