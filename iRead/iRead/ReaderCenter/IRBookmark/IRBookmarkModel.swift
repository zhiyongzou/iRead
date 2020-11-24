//
//  IRBookmarkModel.swift
//  iRead
//
//  Created by zzyong on 2020/11/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBookmarkModel: NSObject {

    var markTime: TimeInterval = 0
    var chapterName: String?
    var content: String?
    var chapterIdx: Int = 0
    /// 书签文本起始位置
    var textLoction: Int = 0
    
    init(chapterIdx: Int, chapterName: String?, textLoction: Int) {
        super.init()
        self.chapterIdx = chapterIdx
        self.chapterName = chapterName
        self.markTime = Date().timeIntervalSince1970
        self.textLoction = textLoction
    }
}

