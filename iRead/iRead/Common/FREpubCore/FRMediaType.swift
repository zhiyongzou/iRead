//
//  FRMediaType.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 29/04/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

/**
 FRMediaType is used to tell the type of content a resource is.

 Examples of mediatypes are image/gif, text/css and application/xhtml+xml
 */
public struct FRMediaType: Equatable {
    public let name: String
    public let defaultExtension: String
    public let extensions: [String]

    public init(name: String, defaultExtension: String, extensions: [String] = []) {
        self.name = name
        self.defaultExtension = defaultExtension
        self.extensions = extensions
    }

}

// MARK: - Equatable

/// :nodoc:
public func == (lhs: FRMediaType, rhs: FRMediaType) -> Bool {
    guard lhs.name == rhs.name else { return false }
    guard lhs.defaultExtension == rhs.defaultExtension else { return false }
    guard lhs.extensions == rhs.extensions else { return false }
    return true
}


/**
 Manages mediatypes that are used by epubs.
 */
extension FRMediaType {
    static let xhtml = FRMediaType(name: "application/xhtml+xml", defaultExtension: "xhtml", extensions: ["htm", "html", "xhtml", "xml"])
    static let epub = FRMediaType(name: "application/epub+zip", defaultExtension: "epub")
    static let ncx = FRMediaType(name: "application/x-dtbncx+xml", defaultExtension: "ncx")
    static let opf = FRMediaType(name: "application/oebps-package+xml", defaultExtension: "opf")
    static let javaScript = FRMediaType(name: "text/javascript", defaultExtension: "js")
    static let css = FRMediaType(name: "text/css", defaultExtension: "css")

    // images
    static let jpg = FRMediaType(name: "image/jpeg", defaultExtension: "jpg", extensions: ["jpg", "jpeg"])
    static let png = FRMediaType(name: "image/png", defaultExtension: "png")
    static let gif = FRMediaType(name: "image/gif", defaultExtension: "gif")
    static let svg = FRMediaType(name: "image/svg+xml", defaultExtension: "svg")

    // fonts
    static let ttf = FRMediaType(name: "application/x-font-ttf", defaultExtension: "ttf")
    static let ttf1 = FRMediaType(name: "application/x-font-truetype", defaultExtension: "ttf")
    static let ttf2 = FRMediaType(name: "application/x-truetype-font", defaultExtension: "ttf")
    static let openType = FRMediaType(name: "application/vnd.ms-opentype", defaultExtension: "otf")
    static let woff = FRMediaType(name: "application/font-woff", defaultExtension: "woff")

    // audio
    static let mp3 = FRMediaType(name: "audio/mpeg", defaultExtension: "mp3")
    static let mp4 = FRMediaType(name: "audio/mp4", defaultExtension: "mp4")
    static let ogg = FRMediaType(name: "audio/ogg", defaultExtension: "ogg")

    static let smil = FRMediaType(name: "application/smil+xml", defaultExtension: "smil")
    static let xpgt = FRMediaType(name: "application/adobe-page-template+xml", defaultExtension: "xpgt")
    static let pls = FRMediaType(name: "application/pls+xml", defaultExtension: "pls")

    static let mediatypes = [xhtml, epub, ncx, opf, jpg, png, gif, javaScript, css, svg, ttf, ttf1, ttf2, openType, woff, mp3, mp4, ogg, smil, xpgt, pls]

    /**
     Gets the MediaType based on the file mimetype.
     - parameter name:     The mediaType name
     - parameter fileName: The file name to extract the extension
     - returns: A know mediatype or create a new one.
     */
    static func by(name: String, fileName: String?) -> FRMediaType {
        for mediatype in mediatypes {
            if mediatype.name == name {
                return mediatype
            }
        }
        let ext = fileName?.pathExtension ?? ""
        return FRMediaType(name: name, defaultExtension: ext)
    }

    /**
     Gets the MediaType based on the file extension.
     */
    static func by(fileName: String) -> FRMediaType? {
        let ext = "." + (fileName as NSString).pathExtension
        return mediatypes.filter({ $0.extensions.contains(ext) }).first
    }

    /**
     Compare if the resource is a image.
     - returns: `true` if is a image and `false` if not
     */
    static func isBitmapImage(_ mediaType: FRMediaType) -> Bool {
        return mediaType == jpg || mediaType == png || mediaType == gif
    }

    /**
     Gets the MediaType based on the file extension.
     */
    static func determineMediaType(_ fileName: String) -> FRMediaType? {
        let ext = fileName.pathExtension

        for mediatype in mediatypes {
            if mediatype.defaultExtension == ext {
                return mediatype
            }
            if mediatype.extensions.contains(ext) {
                return mediatype
            }
        }
        return nil
    }
}
