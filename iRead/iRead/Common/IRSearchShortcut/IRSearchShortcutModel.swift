//
//  IRSearchShortcutModel.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutModel: NSObject {
    
    enum SearchTextType {
        case text
        case bing
        case sogou
        case baidu
    }
    
    var type: SearchTextType = .text
    var content: String?

    class func modelWithContent(_ content: String?, type: SearchTextType = .text) -> IRSearchShortcutModel {
        let model = IRSearchShortcutModel()
        model.type = type
        model.content = content
        return model
    }
}
