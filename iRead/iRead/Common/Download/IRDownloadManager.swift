//
//  IRBookDownloadManager.swift
//  iRead
//
//  Created by zzyong on 2022/2/13.
//  Copyright © 2022 iread.com. All rights reserved.
//

import UIKit
import PKHUD
import CommonLib
import Alamofire
import SVProgressHUD

class IRDownloadManager: NSObject {
    
    static var isDownloading = false
    static var downloadQueue = NSMutableArray()

    class func shouldDownloadFileWithUrl(_ url: String?) -> Bool {
        
        guard let url = url else { return false }
        
        if !url.hasPrefix("http") {
            return false
        }
        
        //  || url.hasSuffix(".txt") || url.hasSuffix(".pdf"
        if url.hasSuffix(".epub") || url.contains(".epub") {
            showDownloadAlertWithTitle("书籍下载", url: url)
            return true
        } else {
            return false
        }
    }
    
    class func showDownloadAlertWithTitle(_ title: String, url: String) {
        let downloadAlert = UIAlertController.init(title: title, message: url, preferredStyle: .alert)
        downloadAlert.view.tintColor = .systemBlue
        let download = UIAlertAction.init(title: "下载", style: .default) { (action) in
            downloadFileWithUrl(url)
        }
        let cancle = UIAlertAction.init(title: "取消", style: .default) { action in
            
        }
        
        downloadAlert.addAction(cancle)
        downloadAlert.addAction(download)
        
        if let rootVc = UIApplication.shared.keyWindow?.rootViewController {
            rootVc.present(downloadAlert, animated: true, completion: nil)
        }
    }
    
    class func downloadFileWithUrl(_ url: String) {
        
        if isDownloading {
            return
        } else {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setMaximumDismissTimeInterval(1)
            SVProgressHUD.showProgress(0, status: "0%")
            isDownloading = true
            let destination: DownloadRequest.Destination = { _, _ in
                let documentsURL = URL.init(fileURLWithPath: IRFileManager.fileDownloadPath)
                let lastPathComponent = (url.lastPathComponent as NSString)
                let range = lastPathComponent.range(of: ".epub")
                let bookName = lastPathComponent.substring(to: range.length + range.location)
                IRDebugLog(bookName)
                let fileURL = documentsURL.appendingPathComponent(bookName)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            AF.download(url, to: destination).downloadProgress { progress in
                let totalUnitCount: Float = Float(progress.totalUnitCount)
                let completedUnitCount: Float = Float(progress.completedUnitCount)
                let currentProgress = completedUnitCount / totalUnitCount
                SVProgressHUD.showProgress(currentProgress, status: "\(Int(floorf(currentProgress * 100)))%")
            }.responseData { response in
                if response.error == nil, let bookPath = response.fileURL?.path {
                    IRFileManager.shared.addEpubBookByWifiUploadBookPath(bookPath)
                    SVProgressHUD.showSuccess(withStatus: nil)
                } else {
                    SVProgressHUD.showError(withStatus: nil)
                }
                isDownloading = false
            }
        }
    }
}
