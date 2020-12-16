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
    
    class func creatBookshelfTableIfNeeded(withName name: String) {
        if hasCreated {
            return
        }
        let sql = "CREATE TABLE IF NOT EXISTS \(name)" + "(coverImage \(IRDBType.BLOB.rawValue)," +
                                                         "bookName \(IRDBType.TEXT.rawValue)," +
                                                         "progress \(IRDBType.INTEGER.rawValue)," +
                                                         "bookPath \(IRDBType.TEXT.rawValue)"
                                                
                                            
        
        let success = IRDBManager.shared.executeUpdate(sql, values: nil)
        if success {
            hasCreated = true
            IRDebugLog("Bookshelf table creat succeed")
        } else {
            IRDebugLog("Bookshelf table creat failed")
        }
    }
}
