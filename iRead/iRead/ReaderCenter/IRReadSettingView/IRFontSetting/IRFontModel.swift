//
//  IRFontModel.swift
//  iRead
//
//  Created by zzyong on 2020/10/20.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRFontModel: NSObject {
    
    var dispalyName: String
    var fontName: String
    var isDownload = false
    
    init(dispalyName: String, fontName: String) {
        self.dispalyName = dispalyName
        self.fontName = fontName
        self.isDownload = UIFont.init(name: fontName, size: 20) != nil
    }
}
