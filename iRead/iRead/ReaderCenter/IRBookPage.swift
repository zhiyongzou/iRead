//
//  IRBookPage.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBookPage: NSObject {
    
    var content: NSAttributedString?
    var pageIdx: Int = 0
    var chapterIdx: Int = 0
    
    class func bookPage(withPageIdx pageIdx: Int, chapterIdx: Int) -> IRBookPage {
        let page = IRBookPage()
        page.pageIdx = pageIdx
        page.chapterIdx = chapterIdx
        return page
    }
}
