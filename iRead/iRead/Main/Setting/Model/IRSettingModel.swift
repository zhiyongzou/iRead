//
//  IRSettingModel.swift
//  iRead
//
//  Created by zzyong on 2021/12/25.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit

class IRSettingModel: NSObject {
    
    typealias ViewControllerBlock = () -> UIViewController
    
    typealias ClickActionBlock = () -> Void
    
    /// 底部分割线
    var hiddenSeparator = false
    
    /// 标题
    var title: String?
    
    /// 优先 VC
    var viewController: ViewControllerBlock?
    
    /// 其次 ClickAction
    var clickAction: ClickActionBlock?
}
