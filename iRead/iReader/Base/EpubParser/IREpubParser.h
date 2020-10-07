//
//  IREpubParser.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

//MARK:依赖第三方库 ZipArchive

@class IREpubBook;

typedef void(^ReadEpubCompletion)(IREpubBook *book, NSError *error);

@interface IREpubParser : NSObject

+ (void)async_parseEpubBookWithFilePath:(NSString *)filePath bookName:(NSString *)bookName completion:(ReadEpubCompletion)completion;

@end

