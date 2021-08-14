//
//  BSMenuModel.swift
//  iRead
//
//  Created by zzyong on 2021/3/14.
//  Copyright © 2021 zzyong. All rights reserved.
//

import Foundation

class BSMenuModel: NSObject {
    
    enum MenuType: Int {
        case wifi
        case style
    }
    
    var title: String
    var imageName: String
    var type: MenuType?
    
    // 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸
    init(title: String, imageName: String, type: MenuType) {
        self.title = title
        self.imageName = imageName
        self.type = type
        
        super.init()
    }
}
