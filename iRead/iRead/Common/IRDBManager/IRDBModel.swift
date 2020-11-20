//
//  IRDBModel.swift
//  iRead
//
//  Created by zzyong on 2020/10/27.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

/**
 SQLite 存储类型
 */
enum IRDBType: String {
    /// 值是一个 NULL 值
    case NULL    = "NULL"
    
    /// 值是一个带符号的整数，根据值的大小存储在 1、2、3、4、6 或 8 字节中
    case INTEGER = "INTEGER"
    
    /// 值是一个浮点值，存储为 8 字节的 IEEE 浮点数字。
    case REAL    = "REAL"
    
    /// 值是一个文本字符串，使用数据库编码（UTF-8、UTF-16BE 或 UTF-16LE）存储。
    case TEXT    = "TEXT"
    
    /// 值是一个 blob 数据，完全根据它的输入存储。
    case BLOB    = "BLOB"
}

struct IRDBModel {
    /// 字段名
    var name: String
    
    /// 字段类型
    var type: IRDBType
    
    /// 值
    var value: Any?
    
    /// 是否可 nil
    var nullable = true
    
    /// 是否主键
    var isPrimaryKey = false
    
}
