//
//  IRReaderCenterController.h
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRBaseViewController.h"

@class IREpubBook;

@interface IRReaderCenterController : IRBaseViewController

- (instancetype)initWithBook:(IREpubBook *)book;

- (void)selectChapterAtIndex:(NSUInteger)chapterIndex;
- (void)selectChapterAtIndex:(NSUInteger)chapterIndex pageAtIndex:(NSUInteger)pageInadex;

@end
