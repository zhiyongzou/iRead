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

let kIreadBookTable = "iread_book_table"

class IRDBManager: NSObject {

    static let shared: IRDBManager = IRDBManager()
    
    lazy var fmdb: FMDatabase = {
        var dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        dbPath = dbPath?.appendingPathComponent("iread.sqlite")
        IRDebugLog(dbPath);
        let fmdb = FMDatabase.init(path: dbPath)
        return fmdb
    }()
    
    func open() -> Bool {
        if fmdb.isOpen {
            return true
        }
        if fmdb.open() {
            IRDebugLog("Open database Success");
            return true
        } else {
            print("Open database Fail")
            return false
        }
    }
    
    func close() -> Bool {
        if !fmdb.isOpen {
            return true
        }
        if fmdb.close() {
            IRDebugLog("Close database Success")
            return true
        } else {
            print("Close database Fail")
            return false
        }
    }
    
    func creatTable(_ tableName: String, values: [IRDBModel]) -> Bool {
        
        if values.count == 0 || tableName.count == 0 {
            return false
        }
        
        var valueString: String = ""
        for model in values {
            if valueString.count > 0 {
                valueString.append(", ")
            }
            valueString.append("\(model.name) \(model.type.rawValue)")
            if !model.nullable {
                valueString.append("NOT NULL")
            }
        }
        
        let sql = "CREATE TABLE IF NOT EXISTS \(tableName) (\(valueString))"
        do {
            try fmdb.executeUpdate(sql, values: nil)
            return true
        } catch {
            print("failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func insertValues(_ values: [IRDBModel], intoTable tableName: String) -> Bool {
        
        if values.count == 0 || tableName.count == 0 {
            return false
        }
        
        var valueName = ""
        var placeholder = ""
        var tableValues = [Any]()
        
        for model in values {
            if valueName.count > 0 {
                valueName.append(", ")
                placeholder.append(", ")
            }
            valueName.append("\(model.name)")
            placeholder.append("?")
            tableValues.append(model.value ?? NSNull())
        }
        
        let sql = "INSERT INTO \(tableName) (\(valueName)) VALUES (\(placeholder)"
        
        do {
            try fmdb.executeUpdate(sql, values: tableValues)
            return true
        } catch {
            print("failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func selectValues(_ values: [IRDBModel]?, fromTable tableName: String) -> FMResultSet? {
        
        if tableName.count == 0 {
            return nil
        }
        
        var valueName = ""
        if let values = values {
            for model in values {
                if valueName.count > 0 {
                    valueName.append(", ")
                }
                valueName.append("\(model.name)")
            }
        } else {
            // 获取所有可用的字段: SELECT * FROM table_name
            valueName = "*"
        }
        
        let sql = "SELECT \(valueName) FROM \(tableName)"
        do {
            return try fmdb.executeQuery(sql, values: nil)
        } catch  {
            print("failed: \(error.localizedDescription)")
            return nil
        }
    }
}
