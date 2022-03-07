//
//  IRFileModel.swift
//  iRead
//
//  Created by zzyong on 2022/3/6.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit

class IRFileModel: NSObject {
    
    enum fileState: Int {
        case ready = 0
        case downloading = 1
        case finish = 2
    }

    var name: String?
    var fileUrl: String?
    var state = fileState.ready
}
