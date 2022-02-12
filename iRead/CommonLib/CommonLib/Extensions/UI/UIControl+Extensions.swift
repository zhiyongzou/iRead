//
//  UIControl+Extension.swift
//  iRead
//
//  Created by zzyong on 2020/11/17.
//  Copyright © 2020 zzyong. All rights reserved.
//
// https://stackoverflow.com/questions/24133058/is-there-a-way-to-set-associated-objects-in-swift
// https://stackoverflow.com/questions/808503/uibutton-making-the-hit-area-larger-than-the-default-hit-area/13067285

import UIKit
import ObjectiveC

public extension UIControl {
    
    private struct AssociatedKey {
        static var kTouchPointOffset = "kTouchPointOffset"
    }
    
    var touchPointOffset: CGFloat {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.kTouchPointOffset) else { return 0 }
            return value as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.kTouchPointOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if touchPointOffset == 0 {
            return super.point(inside: point, with: event)
        }
        let relativeFrame = self.bounds
        let offset = -touchPointOffset
        let hitFrame = relativeFrame.inset(by: UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset))
        return hitFrame.contains(point)
    }
}
