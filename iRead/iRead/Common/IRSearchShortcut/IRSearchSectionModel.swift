//
//  IRSearchSectionModel.swift
//  iRead
//
//  Created by zzyong on 2022/2/6.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchSectionModel: NSObject {
    enum SearchShortcutType {
        case common
        case history
    }
    
    var type: SearchShortcutType = .common
    var title: String?
    var items: [IRSearchShortcutModel]?
}
