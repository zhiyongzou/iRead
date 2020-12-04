//
//  IRFileShareManager.swift
//  iRead
//
//  Created by zzyong on 2020/12/4.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib
import SSZipArchive

// Import Epub
extension Notification {
    static let IRImportEpubBookNotification = Notification.Name("IRImportEpubBook")
}

enum IRFileType: String {
    case Epub = "epub"
}

enum IRDirectoryType: String {
    case Books = "books"
    /// AirDrop
    case Inbox = "Inbox"
}

class IRFileManager: NSObject {
    
    static let shared: IRFileManager = IRFileManager()
    
    /// epub books path
    static let bookUnzipPath: String = {
        let path = IRDocumentDirectoryPath + "/" + IRDirectoryType.Books.rawValue
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(at: URL.init(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }()
    
    var fileQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "ir_file_queue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .default
        return queue
    }()
    
    var bookPathList: [String] {
        get {
            // 注意：subpathsOfDirectory 会返回所有子路径(递归)
            guard let pathList = try? FileManager.default.contentsOfDirectory(atPath: IRFileManager.bookUnzipPath) else { return [String]() }
            var bookPaths = [String]()
            for path in pathList {
                bookPaths.append(IRFileManager.bookUnzipPath + "/" + path)
            }
            return bookPaths
        }
    }
    
    func deleteAirDropFileContents() {
        let path = IRDocumentDirectoryPath + "/" + IRDirectoryType.Inbox.rawValue
        try? FileManager.default.removeItem(atPath: path)
        IRDebugLog("")
    }
    
    func addEpubBookByShareUrl(_ url: URL) {
        // System-Declared Uniform Type Identifiers: https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
        let isEpub = url.isFileURL && url.pathExtension == IRFileType.Epub.rawValue
        if !isEpub { return }
        
        fileQueue.addOperation {
            defer {
                self.deleteAirDropFileContents()
            }
            
            let lastPathComponent = url.lastPathComponent
            // filter duplicate file which shared by Airdrop if needed
            if let airdropFlagIdx = lastPathComponent.lastIndex(of: "-") {
                let bookName = String(lastPathComponent[..<airdropFlagIdx]) + "." + IRFileType.Epub.rawValue
                if FileManager.default.fileExists(atPath: IRFileManager.bookUnzipPath + "/" + bookName) {
                    IRDebugLog("Duplicate file \(bookName)")
                    return
                }
            }
            
            let toPath = IRFileManager.bookUnzipPath + "/" + lastPathComponent
            if FileManager.default.fileExists(atPath: toPath) {
                IRDebugLog("Exist file \(lastPathComponent)")
                return
            }
            
            // 注意：不要使用 url.absoluteString，否则会报下面错误： couldn’t be moved to “tmp” because either the former doesn't exist, or the folder containing the latter doesn't exist
            SSZipArchive.unzipFile(atPath: url.path, toDestination: toPath)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.IRImportEpubBookNotification, object: toPath)
            }
        }
    }
}
