//
//  IRBaseViewcontroller.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/9/24.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

open class IRBaseViewcontroller: UIViewController {
    
    open var backButtonItem: UIBarButtonItem?
    
    #if DEBUG
    deinit {
        IRDebugLog(self)
    }
    #endif
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        IRDebugLog(self)
    }

    open override func viewWillAppear(_ animated: Bool) {
        IRDebugLog(self)
        return super.viewWillAppear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        IRDebugLog(self)
        return super.viewDidDisappear(animated)
    }
    
    open func disableLargeTitles() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    open func enableLargeTitles() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    open func setupLeftBackBarButton() {
        let backImg = UIImage.init(named: "arrow_back")?.template
        backButtonItem = UIBarButtonItem.init(image: backImg, style: .plain, target: self, action: #selector(didClickedLeftBackItem(item:)))
        backButtonItem?.tintColor = UIColor.rgba(80, 80, 80, 1)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func didClickedLeftBackItem(item: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
