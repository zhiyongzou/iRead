//
//  IRBookmark.swift
//  iRead
//
//  Created by zzyong on 2020/11/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRBookmarkManager: NSObject {

    static var tableListdMap = [String: Bool]()
    
    class func tableName(withBookName name: String) -> String {
        var tablePrefix = name
        tablePrefix = tablePrefix.replacingOccurrences(of: " ", with: "")
        return tablePrefix + "_bookmark_table"
    }

    class func creatBookmarkTable(withName name: String) {
        var hasCreated = false
        if let value = tableListdMap[name] {
            hasCreated = value
        }
        if hasCreated {
            return
        }
        
        // //Mutil PRIMARY KEY: https://stackoverflow.com/questions/734689/sqlite-primary-key-on-multiple-columns
        let sql = "CREATE TABLE IF NOT EXISTS \(name)" + "(chapterIdx \(IRDBType.INTEGER.rawValue)," +
                                                         "textLoction \(IRDBType.INTEGER.rawValue)," +
                                                         "markTime \(IRDBType.INTEGER.rawValue)," +
                                                         "chapterName \(IRDBType.TEXT.rawValue)," +
                                                         "content \(IRDBType.TEXT.rawValue)," +
                                                         "PRIMARY KEY(chapterIdx, textLoction))"
        
        let success = IRDBManager.shared.executeUpdate(sql, values: nil)
        if success {
            tableListdMap[name] = true
            IRDebugLog("Bookmark table creat succeed")
        } else {
            IRDebugLog("Bookmark table creat failed")
        }
    }
    
    class func insertBookmark(_ mark: IRBookmarkModel, into bookName: String) {
        let tableName = self.tableName(withBookName: bookName)
        self.creatBookmarkTable(withName: tableName)
        let sql = "INSERT INTO \(tableName)" + "(chapterIdx, textLoction, markTime, chapterName, content)" + "VALUES (?,?,?,?,?)"
        let values: [Any] = [mark.chapterIdx, mark.textLoction, mark.markTime, mark.chapterName == nil ? NSNull() : mark.chapterName!, mark.content == nil ? NSNull() : mark.content!]
        let success = IRDBManager.shared.executeUpdate(sql, values: values)
        if !success {
            IRDebugLog("Insert failed")
        } else {
            IRDebugLog("Insert succeed")
        }
        IRDBManager.shared.close()
    }
    
    /**
     1. https://stackoverflow.com/questions/9475995/delete-row-from-sqlite-database-with-fmdb
     2. DELETE FROM table_name WHERE [condition]; 使用 AND 或 OR 运算符来结合 N 个数量的条件
     */
    class func deleteBookmark(from bookName: String, chapterIdx: Int, textRange: NSRange) {
        let tableName = self.tableName(withBookName: bookName)
        self.creatBookmarkTable(withName: tableName)
        
        let sql = "DELETE FROM \(tableName) WHERE chapterIdx = ? AND textLoction >= ? AND textLoction < ?"
        let success = IRDBManager.shared.executeUpdate(sql, values: [chapterIdx, textRange.location, textRange.location + textRange.length])
        if !success {
            IRDebugLog("Delete failed")
        } else {
            IRDebugLog("Delete succeed")
        }
        IRDBManager.shared.close()
    }
}

// MARK: Public
extension IRBookmarkManager {
    
    class func loadBookmarkList(withBookName name: String) -> [IRBookmarkModel] {
        let tableName = self.tableName(withBookName: name)
        let sql = "SELECT * FROM \(tableName)"
        guard let resultSet = IRDBManager.shared.executeQuery(sql, values: nil) else {
            return [IRBookmarkModel]()
        }
        
        var bookmarkList = [IRBookmarkModel]()
        while resultSet.next() {
            let markTime = resultSet.double(forColumn: "markTime")
            let chapterIdx = resultSet.long(forColumn: "chapterIdx")
            let textLoction = resultSet.long(forColumn: "textLoction")
            let chapterName = resultSet.string(forColumn: "chapterName")
            let content = resultSet.string(forColumn: "content")
 
            let bookmark = IRBookmarkModel.init(chapterIdx: chapterIdx, chapterName: chapterName, textLoction: textLoction)
            bookmark.markTime = markTime
            bookmark.content = content
            bookmarkList.append(bookmark)
        }
        defer {
            IRDBManager.shared.close()
        }
        return bookmarkList
    }
}
