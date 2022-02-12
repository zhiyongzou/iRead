//
//  IRSearchShortcutViewDelegate.swift
//  iRead
//
//  Created by zzyong on 2022/1/26.
//  Copyright © 2022 iread.com. All rights reserved.
//

import Foundation

@objc protocol IRSearchShortcutViewDelegate: NSObjectProtocol {
    
    @objc optional func searchShortcutViewWillBeginDragging(_ shortcutView:IRSearchShortcutView)
    
    @objc optional func searchShortcutView(_ shortcutView:IRSearchShortcutView, didSearch shortcut: IRSearchShortcutModel?)

}
