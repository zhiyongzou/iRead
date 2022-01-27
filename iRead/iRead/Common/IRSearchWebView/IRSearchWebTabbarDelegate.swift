//
//  IRSearchWebTabbarDelegate.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import Foundation

@objc protocol IRSearchWebTabbarDelegate: NSObjectProtocol {
    
    @objc optional func searchWebTabbarDidClickBackButton(_ topBar:IRSearchWebTabbar)
    
    @objc optional func searchWebTabbarDidClickForwardButton(_ topBar:IRSearchWebTabbar)
    
    @objc optional func searchWebTabbarDidClickReloadButton(_ topBar:IRSearchWebTabbar)
}
