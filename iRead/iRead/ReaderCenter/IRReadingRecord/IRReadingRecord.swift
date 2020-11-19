//
//  IRReadingRecord.swift
//  iRead
//
//  Created by zzyong on 2020/11/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRReadingRecord: NSObject {

    static let directoryPath = "/ReadingRecord"
    
    class func readingRecord(with bookName: String) -> IRReadingRecordModel {
        
        if let readingRecord = NSKeyedUnarchiver.unarchiveObject(withFile: self.readingRecordPath(with: bookName)) as? IRReadingRecordModel {
            return readingRecord
        }
        return IRReadingRecordModel(0, 0, NSMakeRange(0, 0))
    }
    
    class func setReadingRecord(record: IRReadingRecordModel, bookName: String) -> Void {
        DispatchQueue.global().async {
            NSKeyedArchiver.archiveRootObject(record, toFile: self.readingRecordPath(with: bookName))
        }
    }
    
    class func readingRecordPath(with bookName: String) -> String  {
        let dirPath = IRDocumentDirectoryPath + directoryPath
        var isDir: ObjCBool = false
        let isExist = FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir)
        
        if !isExist && !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: URL.init(fileURLWithPath: dirPath), withIntermediateDirectories: true, attributes: nil)
            } catch  {
                IRDebugLog("Create Directory faile: \(error)")
                return IRDocumentDirectoryPath + "/" + bookName
            }
        }
        return dirPath + "/" + bookName
    }
}
