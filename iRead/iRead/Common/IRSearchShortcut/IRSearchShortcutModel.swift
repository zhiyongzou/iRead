//
//  IRSearchShortcutModel.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutModel: NSObject {
    
    enum SearchShortcutType {
        case common
        case history
    }
    
    var type: SearchShortcutType = .common
    var title: String?
    var items: [String]?

}
