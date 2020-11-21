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
     database.executeUpdate("create table test(x text, y text, z text)", values: nil)
     */
    func creatTable(_ tableName: String, values: [IRDBModel]) -> Bool {
        
        if values.count == 0 || tableName.count == 0 {
            return false
        }
        
        var valueString: String = ""
        var primaryValue: String = ""
        for model in values {
            if valueString.count > 0 {
                valueString.append(", ")
            }
            valueString.append("\(model.name) \(model.type.rawValue)")
            if model.isPrimaryKey {
                if primaryValue.count > 0 {
                    primaryValue.append(", ")
                }
                primaryValue.append(model.name)
            }
            if !model.nullable {
                valueString.append(" NOT NULL")
            }
        }
        if primaryValue.count > 0 {
            //Mutil PRIMARY KEY: https://stackoverflow.com/questions/734689/sqlite-primary-key-on-multiple-columns
            valueString.append(", PRIMARY KEY(\(primaryValue))")
        }
        let sql = "CREATE TABLE IF NOT EXISTS \(tableName) (\(valueString))"
        
        var success = false
        fmdbQueue?.inDatabase({ (db) in
            do {
                try db.executeUpdate(sql, values: nil)
                success = true
            } catch {
                IRDebugLog("failed: \(error.localizedDescription)")
            }
        })
        return success
    }
    
    /**
     database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"]
     */
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
        
        let sql = "INSERT INTO \(tableName) (\(valueName)) VALUES (\(placeholder))"
        var success = false
        fmdbQueue?.inDatabase({ (db) in
            do {
                try db.executeUpdate(sql, values: tableValues)
                success = true
            } catch {
                IRDebugLog("failed: \(error.localizedDescription)")
            }
        })
        return success
    }
    
    /**
     database.executeQuery("select x, y, z from test", values: nil)
     */
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
}
