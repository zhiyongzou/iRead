//
//  IRFontDownload.swift
//  iRead
//
//  Created by zzyong on 2020/10/19.
//  Copyright © 2020 zzyong. All rights reserved.
//
// https://developer.apple.com/videos/play/wwdc2019/227/

import UIKit
import IRCommonLib

protocol IRFontDownloadDelegate: AnyObject {
    
    func fontDownloadDidBegin(_ downloader: IRFontDownload)
    
    func fontDownloadDidFinish(_ downloader: IRFontDownload)
    
    func fontDownloadDidFail(_ downloader: IRFontDownload, error: Error?)
    
    func fontDownloadDownloading(_ downloader: IRFontDownload, progress: Double)
}

class IRFontDownload: NSObject {
    
    var begin = true {
        willSet {
            stop = !newValue
        }
    }
    var stop = false
    
    weak var delegate: IRFontDownloadDelegate?
    
    func downloadFontWithName(_ fontName: String) {
        
        IRDebugLog("Download \(fontName)")
        
        // Create a dictionary with the font's PostScript name.
        let attributes = [kCTFontNameAttribute : fontName] as CFDictionary
        
        // Create a new font descriptor reference from the attributes dictionary.
        let fontDescription = CTFontDescriptorCreateWithAttributes(attributes)
        let descs = [fontDescription] as CFArray
        
        
        // Start processing the font descriptor..
        // This function returns immediately, but can potentially take long time to process.
        // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
        // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
        CTFontDescriptorMatchFontDescriptorsWithProgressHandler(descs, nil) { (state, progressParamater) -> Bool in
            
            let progressValue = (progressParamater as Dictionary)[kCTFontDescriptorMatchingPercentage]?.doubleValue
            switch state {
                case .didBegin: do {
                    OperationQueue.main.addOperation {
                        self.delegate?.fontDownloadDidBegin(self)
                    }
                }

                case .didFinish: do {
                    OperationQueue.main.addOperation {
                        self.delegate?.fontDownloadDidFinish(self)
                    }
                }

                case .downloading: do {
                    OperationQueue.main.addOperation {
                        self.delegate?.fontDownloadDownloading(self, progress: progressValue ?? 0)
                    }
                }
                    
                case .didFailWithError: do {
                    if let error = (progressParamater as Dictionary)[kCTFontDescriptorMatchingError] as? NSError {
                        OperationQueue.main.addOperation {
                            self.delegate?.fontDownloadDidFail(self, error: error)
                        }
                    } else {
                        print("ERROR MESSAGE IS NOT AVAILABLE")
                    }
                }
                    
                default: do {
                    IRDebugLog(String(reflecting: state))
                }
            }
            
            if self.stop {
                return false
            }
            
            return true
        }
    }
}
