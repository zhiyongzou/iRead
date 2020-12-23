//
//  UIImage+Extensions.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/12/23.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

public extension UIImage {
    
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}
