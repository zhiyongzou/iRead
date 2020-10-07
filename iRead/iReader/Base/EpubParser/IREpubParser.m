//
//  IREpubParser.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IREpubHeaders.h"
#import <ZipArchive.h>

static NSString *const kContainerXMLAppendPath = @"META-INF/container.xml";

@implementation IREpubParser

static dispatch_queue_t _ir_epub_parser_queue()
{
    static dispatch_queue_t _ir_epub_parser_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ir_epub_parser_queue = dispatch_queue_create("ir_epub_parser_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return _ir_epub_parser_queue;
}

+ (void)parseEpubBookWithFilePath:(NSString *)filePath bookName:(NSString *)bookName completion:(ReadEpubCompletion)completion
{
    IREpubBook *book = nil;
    NSError *epubError  = nil;
    NSString *errorInfo = nil;
    NSString *unzipPath = nil;
    
    do {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            errorInfo = @"[IREpubParser] Epub book not found";
            NSAssert(NO, errorInfo);
            break;
        }
        
        unzipPath = [[IRFileUtilites applicationCachesDirectory] stringByAppendingPathComponent:bookName];
        IRDebugLog(@"[IREpubParser] Epub unzip Path: %@", unzipPath);
        
        BOOL isDir;
        BOOL needUnzip = ![[NSFileManager defaultManager] fileExistsAtPath:unzipPath isDirectory:&isDir] || !isDir;
        if (needUnzip) {
            ZipArchive *zip = [[ZipArchive alloc] init];
            BOOL openSuccess = [zip UnzipOpenFile:filePath];
            BOOL unzipSuccess = [zip UnzipFileTo:unzipPath overWrite:YES];
            [zip UnzipCloseFile];
            
            if (!openSuccess && !unzipSuccess) {
                errorInfo = @"[IREpubParser] Epub book unzip failed";
                NSAssert(NO, errorInfo);
                break;
            }
        }
    } while (0);
    
    if (!errorInfo.length) {
        
        book = [[IREpubBook alloc] init];
        book.name = bookName;
        [self readContainerXMLWithUnzipPath:unzipPath book:book error:&epubError];
        if (!epubError) {
            [self readOpfWithUnzipPath:unzipPath book:book error:&epubError];
        }
        
    } else {
        epubError = [self epubPareserErrorWithInfo:errorInfo];
    }
    
    runOnMainThread(^{
        completion(book, epubError);
    });
}

+ (void)readContainerXMLWithUnzipPath:(NSString *)unzipPath book:(IREpubBook *)book error:(NSError **)error
{
    NSString *containerXMLPath = [unzipPath stringByAppendingPathComponent:kContainerXMLAppendPath];
    NSData *containerData = [NSData dataWithContentsOfFile:containerXMLPath options:NSDataReadingMappedAlways error:error];
    
    if (!containerData && *error) {
        IRDebugLog(@"[IREpubParser] Creat container data error: %@", *error);
        return;
    }
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:containerData options:0 error:error];
    
    if (!xmlDoc && *error) {
        IRDebugLog(@"[IREpubParser] Container XML parse error: %@", *error);
        return;
    }
    
    GDataXMLElement *rootfiles = [xmlDoc.rootElement elementsForName:@"rootfiles"].firstObject;
    GDataXMLElement *rootfile  = [rootfiles elementsForName:@"rootfile"].firstObject;
    IRMediaType *mediaType = [IRMediaType mediaTypeWithName:[[rootfile attributeForName:@"media-type"] stringValue] fileName:nil];
    book.container = [IRContainer containerWithFullPath:[[rootfile attributeForName:@"full-path"] stringValue]
                                              mediaType:mediaType];
    book.resourcesBasePath = [unzipPath stringByAppendingPathComponent:[book.container.fullPath stringByDeletingLastPathComponent]];
    IRDebugLog(@"[IREpubParser] Resources base path: %@", book.resourcesBasePath);
}

+ (void)readOpfWithUnzipPath:(NSString *)unzipPath book:(IREpubBook *)book error:(NSError **)error
{
    NSString *opfPath = [unzipPath stringByAppendingPathComponent:book.container.fullPath];
    NSData *opfData = [NSData dataWithContentsOfFile:opfPath options:NSDataReadingMappedAlways error:error];
    
    if (!opfData && *error) {
        IRDebugLog(@"[IREpubParser] Creat OPF data error: %@", *error);
        return;
    }
    
    GDataXMLDocument *opfDoc = [[GDataXMLDocument alloc] initWithData:opfData options:0 error:error];
    
    if (!opfDoc && *error) {
        IRDebugLog(@"[IREpubParser] OPF parse error: %@", *error);
        return;
    }
    
    // Package
    GDataXMLElement *package = opfDoc.rootElement;
    book.version = [[package attributeForName:@"version"] stringValue];
    IRDebugLog(@"[IREpubParser] OPF Package version: %@", book.version);
    
    // Metadata
    GDataXMLElement *opfMetadataDoc = [package elementsForName:@"metadata"].firstObject;
    if (opfMetadataDoc) {
        book.opfMetadata = [self readOpfMetadataWithXMLElement:opfMetadataDoc];
        book.author = [IRAuthor authorWithName:book.opfMetadata.creator];
    }
    
    // Manifest
    GDataXMLElement *opfManifestDoc = [package elementsForName:@"manifest"].firstObject;
    if (opfManifestDoc) {
        book.opfManifest = [self readOpfManifestWithXMLElement:opfManifestDoc book:book unzipPath:unzipPath];
    }
    
    if (!book.opfManifest.tocNCXResource && !book.opfManifest.htmlNCXResource) {
        NSString *errorInfo = @"[IREpubParser] ERROR: Could not find table of contents resource. The book don't have a TOC resource.";
        *error = [self epubPareserErrorWithInfo:errorInfo];
        NSAssert(NO, errorInfo);
        return;
    }
    
    // Table of contents
    book.tableOfContents = [self readTableOfContentsWithBook:book error:error];
    book.flatTableOfContents = [self readFlatTableOfContentsWithBook:book];
    
    // Spine
    GDataXMLElement *opfSpineDoc = [package elementsForName:@"spine"].firstObject;
    if (opfSpineDoc) {
        book.opfSpine = [self readOpfSpineWithXMLElement:opfSpineDoc book:book error:error];
    }
}

+ (NSArray *)readFlatTableOfContentsWithBook:(IREpubBook *)book
{
    NSMutableArray *flat = [NSMutableArray array];
    for (IRTocRefrence *tocRefrence in book.tableOfContents) {
        if (tocRefrence.childen.count) {
            [flat addObjectsFromArray:[self countOfTocRefrence:tocRefrence]];
        } else {
            [flat addObject:tocRefrence];
        }
    }
    
    return flat.count ? flat : nil;
}

+ (NSArray *)countOfTocRefrence:(IRTocRefrence *)tocRefrence
{
    NSMutableArray *all = [NSMutableArray arrayWithObject:tocRefrence];
    
    for (IRTocRefrence *toc in tocRefrence.childen) {
        if (toc.childen.count) {
            [all addObjectsFromArray:[self countOfTocRefrence:toc]];
        } else {
            [all addObject:toc];
        }
    }
    
    return all;
}

+ (IROpfSpine *)readOpfSpineWithXMLElement:(GDataXMLElement *)spineElement book:(IREpubBook *)book error:(NSError **)error
{
    IROpfSpine *opfSpine = [[IROpfSpine alloc] init];
    
    // Page progress direction `ltr` or `rtl`
    opfSpine.pageProgressionDirection = [[spineElement attributeForName:@"page-progression-direction"] stringValue];
    
    NSMutableArray *tempSpines = [NSMutableArray arrayWithCapacity:spineElement.childCount];
    for (GDataXMLElement *element in spineElement.children) {
        if (![element isKindOfClass:[GDataXMLElement class]]) {
            continue;
        }
        
        NSString *idref = [[element attributeForName:@"idref"] stringValue];
        if (!idref.length) {
            continue;
        }
        
        NSString *linear = [[element attributeForName:@"linear"] stringValue];
        NSString *resourceId = [book.opfManifest.manifestOfHrefs objectForKey:idref];
        [tempSpines addObject:[IRSpine spineWithResource:[book.opfManifest.resources objectForKey:resourceId ?: @""]
                                                  linear:([linear isEqualToString:@"yes"])]];
    }
    
    opfSpine.spineReferences = tempSpines;
    
    return opfSpine;
}

+ (NSArray<IRTocRefrence *> *)readTableOfContentsWithBook:(IREpubBook *)book error:(NSError **)error
{
    NSMutableArray<IRTocRefrence *> *tableOfContents = nil;
    NSArray *tocItems = nil;
    IRResource *tocResource = book.opfManifest.tocNCXResource ?: book.opfManifest.htmlNCXResource;
    if (!tocResource) {
        return tableOfContents;
    }
    
    NSData *ncxData = [NSData dataWithContentsOfFile:tocResource.fullHref options:NSDataReadingMappedAlways error:error];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:ncxData options:0 error:error];
    
    if ([tocResource.mediaType.defaultExtension isEqualToString:@"ncx"]) {
        tocItems = [[xmlDoc.rootElement elementsForName:@"navMap"].firstObject elementsForName:@"navPoint"];
    } else {
        GDataXMLElement *nav = [[xmlDoc.rootElement elementsForName:@"body"].firstObject elementsForName:@"nav"].firstObject;
        if (!nav) {
            nav = [self findHtmlTocNavTag:[xmlDoc.rootElement elementsForName:@"body"].firstObject];
        }
        tocItems = [[nav elementsForName:@"ol"].firstObject elementsForName:@"li"];
    }
    
    if (!tocItems) {
        return tableOfContents;
    }
    
    tableOfContents = [NSMutableArray arrayWithCapacity:tocItems.count];
    for (GDataXMLElement *element in tocItems) {
        if (![element isKindOfClass:[GDataXMLElement class]]) {
            continue;
        }
        
        IRTocRefrence *toc = [self readTocRefrenceWithXMLElement:element tocResource:tocResource book:book];
        if (toc) {
            [tableOfContents addObject:toc];
        }
    }
    
    return [tableOfContents copy];
}

+ (GDataXMLElement *)findHtmlTocNavTag:(GDataXMLElement *)bodyElement
{
    for (GDataXMLElement *element in bodyElement.children) {
        GDataXMLElement *nav = [element elementsForName:@"nav"].firstObject;
        if (nav) {
            return nav;
        } else {
            [self findHtmlTocNavTag:element];
        }
    }
    
    return nil;
}

+ (IRTocRefrence *)readTocRefrenceWithXMLElement:(GDataXMLElement *)tocElement tocResource:(IRResource *)tocResource book:(IREpubBook *)book
{
    IRTocRefrence *toc = nil;
    if ([tocResource.mediaType.defaultExtension isEqualToString:@"ncx"]) {
    
        NSString *src = [[[tocElement elementsForName:@"content"].firstObject attributeForName:@"src"] stringValue];
        if (!src.length) {
            return toc;
        }
        NSArray *srcSplit = [src componentsSeparatedByString:@"#"];
        toc = [[IRTocRefrence alloc] init];
        toc.fragmentId = srcSplit.count > 1 ? srcSplit.firstObject : @"";
        toc.resource = [book.opfManifest.resources objectForKey:srcSplit.firstObject];
        toc.title = [[[tocElement elementsForName:@"navLabel"].firstObject elementsForName:@"text"].firstObject stringValue];
        
        // Recursively find child
        NSArray *navPoints = [tocElement elementsForName:@"navPoint"];
        if (navPoints.count) {
            NSMutableArray *childen = [NSMutableArray arrayWithCapacity:navPoints.count];
            for (GDataXMLElement *element in navPoints) {
                if (![element isKindOfClass:[GDataXMLElement class]]) {
                    continue;
                }
                
                IRTocRefrence *item = [self readTocRefrenceWithXMLElement:element tocResource:tocResource book:book];
                if (item) {
                    [childen addObject:item];
                }
            }
            toc.childen = childen;
        }
        
    } else {
        NSString *href = [[[tocElement elementsForName:@"a"].firstObject attributeForName:@"href"] stringValue];
        if (!href.length) {
            return toc;
        }
        NSArray *hrefSplit = [href componentsSeparatedByString:@"#"];
        toc = [[IRTocRefrence alloc] init];
        toc.fragmentId = hrefSplit.count > 1 ? hrefSplit.firstObject : @"";
        toc.resource = [book.opfManifest.resources objectForKey:hrefSplit.firstObject];
        toc.title = [[tocElement elementsForName:@"a"].firstObject stringValue];
        
        // Recursively find child
        NSArray *navPoints = [[tocElement elementsForName:@"ol"].firstObject elementsForName:@"li"];
        if (navPoints.count) {
            NSMutableArray *childen = [NSMutableArray arrayWithCapacity:navPoints.count];
            for (GDataXMLElement *element in navPoints) {
                if (![element isKindOfClass:[GDataXMLElement class]]) {
                    continue;
                }
                
                IRTocRefrence *item = [self readTocRefrenceWithXMLElement:element tocResource:tocResource book:book];
                if (item) {
                    [childen addObject:item];
                }
            }
            toc.childen = childen;
        }
    }
    
    return toc;
}

+ (IROpfManifest *)readOpfManifestWithXMLElement:(GDataXMLElement *)opfManifestDoc book:(IREpubBook *)book unzipPath:(NSString *)unzipPath
{
    IROpfManifest *manifest = [[IROpfManifest alloc] init];
    NSMutableDictionary *resources = [NSMutableDictionary dictionaryWithCapacity:opfManifestDoc.childCount];
    NSMutableDictionary *manifestOfHrefs = [NSMutableDictionary dictionaryWithCapacity:opfManifestDoc.childCount];
    NSMutableArray *cssResources = [NSMutableArray arrayWithCapacity:opfManifestDoc.childCount];
    for (GDataXMLElement *element in opfManifestDoc.children) {
        if (![element isKindOfClass:[GDataXMLElement class]]) {
            continue;
        }
        IRResource *resource = [[IRResource alloc] init];
        resource.itemId = [[element attributeForName:@"id"] stringValue];
        resource.properties = [[element attributeForName:@"properties"] stringValue];
        resource.href = [[element attributeForName:@"href"] stringValue];
        resource.fullHref = [[book.resourcesBasePath stringByAppendingPathComponent:resource.href] stringByRemovingPercentEncoding];
        resource.mediaType = [IRMediaType mediaTypeWithName:[[element attributeForName:@"media-type"] stringValue]
                                                   fileName:resource.href];
        [manifestOfHrefs setValue:resource.href forKey:resource.itemId];
        
        if ([resource.mediaType.name isEqualToString:@"text/css"]) {
            [cssResources addObject:resource];
        } else if ([resource.itemId isEqualToString:book.opfMetadata.coverImageId] ||
                   ([resource.itemId isEqualToString:@"cover"] && [resource.mediaType isBitmapImage])) {
            // Cover image
            manifest.coverImageResource = resource;
            book.bookCoverResource = resource;
        } else if ([resource.href.pathExtension isEqualToString:@"ncx"]) {
            manifest.tocNCXResource = resource;
        } else if ([resource.properties isEqualToString:@"nav"]) {
            manifest.htmlNCXResource = resource;
        } else {
            [resources setObject:resource forKey:resource.href];
        }
    }
    
    manifest.resources = resources;
    manifest.manifestOfHrefs = manifestOfHrefs;
    manifest.cssResources = cssResources;
    
    return manifest;
}

+ (IROpfMetadata *)readOpfMetadataWithXMLElement:(GDataXMLElement *)opfMetadataDoc
{
    IROpfMetadata *opfMetadata = [[IROpfMetadata alloc] init];
    for (GDataXMLElement *element in opfMetadataDoc.children) {
        
        if (![element isKindOfClass:[GDataXMLElement class]]) {
            continue;
        }
        
        if ([element.name isEqualToString:@"dc:title"]) {
            opfMetadata.title = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:language"]) {
            opfMetadata.language = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:creator"]) {
            opfMetadata.creator = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:description"]) {
            opfMetadata.bookDesc = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:source"]) {
            opfMetadata.source = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:date"]) {
            opfMetadata.date = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:rights"]) {
            opfMetadata.rights = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:identifier"]) {
            opfMetadata.identifier = [[element attributeForName:@"opf:scheme"] stringValue];
            
        } else if ([element.name isEqualToString:@"dc:subject"]) {
            if (!opfMetadata.subjects) {
                opfMetadata.subjects = [NSMutableArray arrayWithCapacity:opfMetadataDoc.childCount];
            }
            
            NSString *subject = [element stringValue];
            if (subject) {
                [opfMetadata.subjects addObject:subject];
            }
            
        } else if ([element.name isEqualToString:@"meta"]) {
           
            if ([[[element attributeForName:@"name"] stringValue] isEqualToString:@"cover"] ||
                [[[element attributeForName:@"properties"] stringValue] isEqualToString:@"cover-image"]) {
                
                opfMetadata.coverImageId = [[element attributeForName:@"content"] stringValue];
            } else {
                continue;
            }
        }
    }
    
    return opfMetadata;
}

#pragma mark - helper

+ (NSError *)epubPareserErrorWithInfo:(NSString *)info
{
    return [NSError errorWithDomain:@"EpubPareserErrorDomain" code:-1 userInfo:@{@"errorInfo" : info}];
}

#pragma mark - public

+ (void)async_parseEpubBookWithFilePath:(NSString *)filePath bookName:(NSString *)bookName completion:(ReadEpubCompletion)completion
{
    if (!completion) {
        return;
    }
    
    dispatch_async(_ir_epub_parser_queue(), ^{
        [self parseEpubBookWithFilePath:filePath bookName:bookName completion:completion];
    });
}

@end

// MARK: Epub 文件结构
/**
     <1> Mimetype 文件：文件格式
     <2> META-INF 目录：
         作用：用于存放容器信息
         内容：
         1. 基本文件：container.xml
         2. 可选：manifest.xml(文件列表)、metadata.xml(元数据)、signatures.xml(数字签名)、encryption.xml(加密)、rights.xml(权限管理)
     <3> OEDPS(OPS) 目录：
         1. 存放OPF文档、CSS文档、NCX 文档、资源文件（images等）。中文电子书则还包含 TTF文档
         2. content.opf 文件和 toc.ncx 文件为必需。其他可选
 */

//MARK: OPF 文件构成
/*
    1. meatadata
        < dc-metadata >: 核心元素
            < title >, < creator >, < subject >, < description >, < contributor >
            < date >, < type >, < format >, < identifier >, < source >, < language >
            < relation >, < coverage >, < rights >
        < x-metadata >: 扩展元素
    2. manifest
    3. spine
    4. guide
    5. tour
*/

// MARK: Container.xml 文件结构
/**
 <?xml version="1.0" encoding="UTF-8" ?>
 <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
     <rootfiles>
         <rootfile full-path="OPS/fb.opf" media-type="application/oebps-package+xml"/>
     </rootfiles>
 </container>
 
 */
