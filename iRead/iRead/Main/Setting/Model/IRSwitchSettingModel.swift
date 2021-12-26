//
//  IRSwitchSettingModel.swift
//  iRead
//
//  Created by zzyong on 2021/12/26.
//  Copyright © 2021 iread.com. All rights reserved.
//

import UIKit

class IRSwitchSettingModel: IRSettingModel {
    
    typealias SwitchBlock = (UISwitch) -> Void

    var switchValueKey: String?
    
    var valueChangeAction: SwitchBlock?
}
