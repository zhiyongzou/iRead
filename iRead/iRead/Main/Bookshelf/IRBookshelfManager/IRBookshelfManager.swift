//
//  IRBookshelfManager.swift
//  iRead
//
//  Created by zzyong on 2020/12/16.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRBookshelfManager: NSObject {

    static var hasCreated = false
    static let kTableName  = "bookshelf_table"
    static let kCoverImage = "coverImage"
    static let kBookName   = "bookName"
    static let kProgress   = "progress"
    static let kBookPath   = "bookPath"
    static let kInsertTime = "insertTime"
    
    class func creatBookshelfTableIfNeeded() {
        if hasCreated {
            return
        }
        let sql = "CREATE TABLE IF NOT EXISTS \(kTableName)" + "(\(kCoverImage) \(IRDBType.BLOB.rawValue)," +
                                                         "\(kBookName) \(IRDBType.TEXT.rawValue)," +
                                                         "\(kProgress) \(IRDBType.INTEGER.rawValue)," +
                                                         "\(kInsertTime) \(IRDBType.REAL.rawValue)," +
                                                         "\(kBookPath) \(IRDBType.TEXT.rawValue))"
        let success = IRDBManager.shared.executeUpdate(sql, values: nil)
        if success {
            hasCreated = true
            IRDebugLog("Bookshelf table creat succeed")
        } else {
            IRDebugLog("Bookshelf table creat failed")
        }
    }
    
    class func asyncInsertBook(_ book: IRBookModel) {
        DispatchQueue.global().async {
            self.insertBook(book)
        }
    }
    
    class func insertBook(_ book: IRBookModel) {
        self.creatBookshelfTableIfNeeded()
        let sql = "INSERT INTO \(kTableName)" + "(\(kCoverImage), \(kBookName), \(kInsertTime), \(kProgress), \(kBookPath))" + "VALUES (?,?,?,?,?)"
        let imgData = book.coverImage?.jpegData(compressionQuality: 0.8)
        let values: [Any] = [imgData ?? NSNull(), book.bookName, book.insertTime, book.progress, book.bookPath]
        let success = IRDBManager.shared.executeUpdate(sql, values: values)
        if !success {
            IRDebugLog("Insert failed")
        } else {
            IRDebugLog("Insert succeed")
        }
        IRDBManager.shared.close()
    }
    
    class func deleteBook(_ book: IRBookModel) {
        self.creatBookshelfTableIfNeeded()
        let sql = "DELETE FROM \(kTableName) WHERE \(kBookName) = ? AND \(kBookPath) = ?"
        let success = IRDBManager.shared.executeUpdate(sql, values: [book.bookName, book.bookPath])
        if !success {
            IRDebugLog("Delete failed")
        } else {
            IRDebugLog("Delete succeed")
        }
        IRDBManager.shared.close()
    }
    
    class func loadBookList(completion: ([IRBookModel]?, Error?) -> Void) {
        self.creatBookshelfTableIfNeeded()
        let sql = "SELECT * FROM \(kTableName) ORDER BY \(kInsertTime) DESC"
        IRDBManager.shared.executeQuery(sql) {
            guard let resultSet = $0 else { completion(nil, $1); return }
            var bookList = [IRBookModel]()
            while resultSet.next() {
                let book = IRBookModel.init(with: resultSet.string(forColumn: kBookName)!, path: resultSet.string(forColumn: kBookPath)!)
                if let imgData = resultSet.data(forColumn: kCoverImage) {
                    book.coverImage = UIImage.init(data: imgData)
                }
                book.insertTime = Double(resultSet.int(forColumn: kInsertTime))
                book.progress = CGFloat(resultSet.int(forColumn: kProgress))
                bookList.append(book)
            }
            completion(bookList, nil)
        }
        IRDBManager.shared.close()
    }
}
