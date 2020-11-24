//
//  IRDBManager.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/10/26.
//  Copyright © 2020 zzyong. All rights reserved.
//

/**
 
ORM: Object Relational Mapping(对象关系映射)
FMDB: https://github.com/ccgus/fmdb
SQLite 可视化工具： https://github.com/sqlitebrowser/sqlitebrowser
Frequently Asked Questions：https://www.sqlite.org/faq.html
  
SQLite 命令
    CREATE    |  创建一个新的表，一个表的视图，或者数据库中的其他对象。
    ALTER     |  修改数据库中的某个已有的数据库对象，比如一个表。
    DROP      |  删除整个表，或者表的视图，或者数据库中的其他对象。
    INSERT    |  创建一条记录。
    UPDATE    |  修改记录。
    DELETE    |  删除记录。
    SELECT    |  从一个或多个表中检索某些记录。
*/

import IRCommonLib

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

class IRDBManager: NSObject {

    static let shared: IRDBManager = IRDBManager()
    
    lazy var fmdbQueue: FMDatabaseQueue? = {
        var dbPath = IRDocumentDirectoryPath
        dbPath = dbPath.appendingPathComponent("iread.sqlite")
        IRDebugLog(dbPath);
        let queue = FMDatabaseQueue.init(path: dbPath)
        return queue
    }()
    
    func close() {
        fmdbQueue?.close()
    }
    
    /**
     适用于 SELECT 语句
     1. executeQuery("SELECT x, y, z FROM test", values: nil)
     2. 获取所有可用的字段: SELECT * FROM table_name
     */
    func executeQuery(_ sql: String, values: [Any]?) -> FMResultSet? {
        
        var resultSet: FMResultSet?
        fmdbQueue?.inDatabase({ (db) in
            do {
                resultSet = try db.executeQuery(sql, values: nil)
            } catch {
                IRDebugLog("failed: \(error.localizedDescription)")
            }
        })
        return resultSet
    }
    
    /**
     适用于除 SELECT 的其他语句
     1. executeUpdate("create table test(x text, y text, z text)", values: nil)
     2. executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"]
     */
    func executeUpdate(_ sql: String, values: [Any]?) -> Bool {
        
        var success = false
        fmdbQueue?.inDatabase({ (db) in
            do {
                try db.executeUpdate(sql, values: values)
                success = true
            } catch {
                IRDebugLog("failed: \(error.localizedDescription)")
            }
        })
        return success
    }
}
