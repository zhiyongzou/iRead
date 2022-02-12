//
//  UIColor+Extensions.swift
//  CommonLib
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public extension UIColor {
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random() % 255) / 255.0
            let green = CGFloat(arc4random() % 255) / 255.0
            let blue = CGFloat(arc4random() % 255) / 255.0
            
            return self.init(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    class var separatorColor: UIColor {
        get {
            self.init(red: 0, green: 0, blue: 0, alpha: 0.05)
        }
    }
    
    class func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
