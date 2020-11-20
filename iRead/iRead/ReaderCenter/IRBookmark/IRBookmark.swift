//
//  IRBookmark.swift
//  iRead
//
//  Created by zzyong on 2020/11/19.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

class IRBookmark: NSObject {

    static var tableCreatedFinishedMap = [String: Bool]()
    static let tableValues: [IRDBModel] = {
        var chapterName = IRDBModel(name: "chapterName", type: .TEXT)
        var markTime = IRDBModel(name: "markTime", type: .INTEGER)
        var textLoction = IRDBModel(name: "textLoction", type: .INTEGER)
        textLoction.isPrimaryKey = true
        var chapterIdx = IRDBModel(name: "chapterIdx", type: .INTEGER)
        chapterIdx.isPrimaryKey = true
        
        return [chapterName, markTime, chapterIdx, textLoction]
    }()
    
    class func creatBookmarkTable(withName name: String) {
        
        var hasCreated = false
        if let value = tableCreatedFinishedMap[name] {
            hasCreated = value
        }
        if hasCreated {
            return
        }
        let success = IRDBManager.shared.creatTable(name, values: tableValues)
        if success {
            tableCreatedFinishedMap[name] = true
        } else {
            print("Bookmark table creat failed")
        }
    }
    
    class func saveBookmark(_ mark: IRBookmarkModel, to bookName: String) -> Void {
        
        let tableName = self.tableName(withBookName: bookName)
        self.creatBookmarkTable(withName: tableName)
        let success = IRDBManager.shared.insertValues(self.tableValues(withMark: mark), intoTable: tableName)
        if !success {
            print("Insert failed")
        }
    }
    
    class func tableName(withBookName name: String) -> String {
        var tablePrefix = name
        tablePrefix = tablePrefix.replacingOccurrences(of: " ", with: "")
        return tablePrefix + "_bookmark_table"
    }
    
    class func deleteBookmark(_ mark: IRBookmarkModel, to bookName: String) -> Void {
        let tableName = self.tableName(withBookName: bookName)
        self.creatBookmarkTable(withName: tableName)
        
    }
    
    class func tableValues(withMark bookmark: IRBookmarkModel) -> [IRDBModel] {
        var chapterName = IRDBModel(name: "chapterName", type: .TEXT)
        chapterName.value = bookmark.chapterName
        
        var markTime = IRDBModel(name: "markTime", type: .INTEGER)
        markTime.value = bookmark.markTime
        
        var chapterIdx = IRDBModel(name: "chapterIdx", type: .INTEGER)
        chapterIdx.value = bookmark.chapterIdx

        var textLoction = IRDBModel(name: "textLoction", type: .INTEGER)
        textLoction.value = bookmark.textLoction
        
        return [chapterName, markTime, chapterIdx, textLoction]
    }
}

// MARK: Public
extension IRBookmark {
    
    class func loadBookmarkList(withBookName name: String) -> [IRBookmarkModel] {
        let tableName = self.tableName(withBookName: name)
        guard let resultSet = IRDBManager.shared.selectValues(nil, fromTable: tableName) else {
            return [IRBookmarkModel]()
        }
        
        var bookmarkList = [IRBookmarkModel]()
        while resultSet.next() {
            let markTime = resultSet.double(forColumn: "markTime")
            let chapterIdx = resultSet.long(forColumn: "chapterIdx")
            let textLoction = resultSet.long(forColumn: "textLoction")
            let chapterName = resultSet.string(forColumn: "chapterName")
 
            let bookmark = IRBookmarkModel.init(chapterIdx: chapterIdx, chapterName: chapterName, textLoction: textLoction)
            bookmark.markTime = markTime
            bookmarkList.append(bookmark)
        }
        
        return bookmarkList
    }
}
