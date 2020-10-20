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

class IRFontDownload: NSObject {
    
    var stop = true
    
    func downloadFontWithName(_ fontName: String) {
        
        IRDebugLog(fontName)
        
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
                IRDebugLog("didBegin")
            }
            
            case .didMatch: do {
                IRDebugLog("didMatch")
            }
                
            case .didFinish: do {
                IRDebugLog("didFinish")
            }
                
            case .willBeginDownloading: do {
                IRDebugLog("willBeginDownloading")
            }
            case .didFinishDownloading: do {
                IRDebugLog("didFinishDownloading")
            }
                
            case .downloading: do {
                IRDebugLog("downloading#####\(progressValue ?? 0.0)")
            }
                
            case .didFailWithError:
                if let error = (progressParamater as Dictionary)[kCTFontDescriptorMatchingError] as? NSError {
                    print(error.description)
                } else {
                    print("ERROR MESSAGE IS NOT AVAILABLE")
                }
                
            default: print(String(reflecting: state))
            }
            
            return self.stop
        }
    }
}
