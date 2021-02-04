//
//  AppDelegate.swift
//  iRead
//
//  Created by zzyong on 2020/2/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import PKHUD
import IRCommonLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

#if DEBUG
    lazy var flexWindow: UIWindow = UIWindow()
#endif
    
    var window: UIWindow?
    var rootViewController: IRNavigationController!
    lazy var mainViewController = IRMainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
#if DEBUG
        setupDebugConfig()
#endif
        setupMainViewController()
        
        return true
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        addEpubBookByShareUrl(url)
        return true
    }
}

// MARK: Private
extension AppDelegate {
    
    func setupMainViewController() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        mainViewController.view.backgroundColor = .white
        rootViewController = IRNavigationController.init(rootViewController: mainViewController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        initReadConfig()
    }
    
    func initReadConfig() {
        var safeInsets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safeInsets = window!.safeAreaInsets
        }
        
        if safeInsets.bottom == 0 || safeInsets.top == 0 {
            safeInsets = UIEdgeInsets.init(top: 30, left: 0, bottom: 30, right: 0)
        }
        
        let width = window!.width - IRReaderConfig.horizontalSpacing * 2
        let height = window!.height - safeInsets.top - safeInsets.bottom - IRReaderConfig.pageIndexSpacing
        let maxSize: CGFloat = 1000
        IRReaderConfig.pageSzie = CGSize.init(width: min(maxSize, width), height: min(maxSize, height))
        IRReaderConfig.initReaderConfig()
    }
    
    func addEpubBookByShareUrl(_ url: URL) {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        indicatorView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        HUD.show(.customView(view: indicatorView))
        IRFileManager.shared.addEpubBookByShareUrl(url) { bookPath, success in
            defer {
                HUD.hide()
            }
            guard let bookPath = bookPath, success else {
                return
            }
            if let topViewController = self.rootViewController.topViewController {
                if topViewController.isMember(of: IRReaderCenterViewController.self) {
                    topViewController.navigationController?.popViewController(animated: false)
                }
            }
            
            let readerCenter = IRReaderCenterViewController.init(withPath: bookPath)
            readerCenter.delegate = self.mainViewController.bookshelfVC
            self.rootViewController.pushViewController(readerCenter, animated: true)
        }
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
