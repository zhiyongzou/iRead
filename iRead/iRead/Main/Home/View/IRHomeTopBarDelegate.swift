//
//  IRHomeTopBarDelegate.swift
//  iRead
//
//  Created by zzyong on 2022/1/22.
//  Copyright © 2022 iread.com. All rights reserved.
//

import Foundation

@objc protocol IRHomeTopBarDelegate: NSObjectProtocol {
    
    @objc optional func homeTopBarDidClickSearchButton(_ topBar:IRHomeTopBar)
    
    @objc optional func homeTopBarDidClickScanButton(_ topBar:IRHomeTopBar)
    
    @objc optional func homeTopBarDidClickSettingButton(_ topBar:IRHomeTopBar)
}
