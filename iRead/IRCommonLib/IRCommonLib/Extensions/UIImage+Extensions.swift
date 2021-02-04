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
    
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    // https://nshipster.com/image-resizing/
    func scaled(toWidth: CGFloat, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let imgScale = toWidth / size.width
        let newHeight = size.height * imgScale
        let newSize = CGSize(width: toWidth, height: newHeight)
        let format = UIGraphicsImageRendererFormat.init()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { (context) in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
