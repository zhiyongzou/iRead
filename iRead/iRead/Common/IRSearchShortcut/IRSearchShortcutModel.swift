//
//  IRSearchShortcutModel.swift
//  iRead
//
//  Created by zzyong on 2022/1/23.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRSearchShortcutModel: NSObject {
    
    var title: String?
    var content: String?

    class func modelWithTitle(_ title: String?, content: String?) -> IRSearchShortcutModel {
        let model = IRSearchShortcutModel()
        model.title = title
        model.content = content
        return model
    }
}
