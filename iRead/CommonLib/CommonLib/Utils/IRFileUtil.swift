//
//  IRFileUtil.swift
//  CommonLib
//
//  Created by zzyong on 2022/2/5.
//

import Foundation

/// Documents
public let IRDocumentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

/// Library
public let IRLibraryDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!

/// Library/Caches
public let IRCachesDirectoryPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
