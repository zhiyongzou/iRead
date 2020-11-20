//
//  IRReadingRecordModel.swift
//  iRead
//
//  Created by zzyong on 2020/11/18.
//  Copyright © 2020 zzyong. All rights reserved.
//
/**
 1. 指定构造器是类中最主要的构造器
 2. 当存储型属性分配默认值或者在构造器中设置初始值时，它们的值是被直接设置的，不会触发任何属性观察者
 3. 类里面的所有存储型属性——包括所有继承自父类的属性——都必须在构造过程中设置初始值
 
 Swift 构造器之间的代理调用遵循以下三条规则:
     规则 1
         指定构造器必须调用其直接父类的的指定构造器。
     规则 2
         便利构造器必须调用同类中定义的其它构造器。
     规则 3
         便利构造器最后必须调用指定构造器。
         
  init? : 可失败构造器会创建一个类型为自身类型的可选类型的对象。通过 return nil 语句来表明可失败构造器在何种情况下应该 “失败”
 */

import Foundation

class IRReadingRecordModel: NSObject ,NSCoding {
    
    var chapterIdx: Int = 0
    var pageIdx: Int = 0
    var textRange = NSMakeRange(0, 0)
    
    init(_ chapterIdx: Int, _ pageIdx: Int, _ range: NSRange) {
        super.init()
        self.chapterIdx = chapterIdx
        self.pageIdx = pageIdx
        self.textRange = range
    }
    
    required init?(coder: NSCoder) {
        super.init()
        chapterIdx = coder.decodeInteger(forKey: "chapterIdx")
        pageIdx =  coder.decodeInteger(forKey: "pageIdx")
        if let range = coder.decodeObject(forKey: "textRange") as? NSRange {
            textRange = range
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(chapterIdx, forKey: "chapterIdx")
        coder.encode(pageIdx, forKey: "pageIdx")
        coder.encode(textRange, forKey: "textRange")
    }
}

