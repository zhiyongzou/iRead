//
//  UIColor+Extensions.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let red = CGFloat(arc4random() % 255) / 255.0
        let green = CGFloat(arc4random() % 255) / 255.0
        let blue = CGFloat(arc4random() % 255) / 255.0
        
        return self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
