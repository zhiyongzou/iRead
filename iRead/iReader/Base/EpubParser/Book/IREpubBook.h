//
//  IREpubBook.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRAuthor, IRResource, IRTocRefrence, IRContainer;
@class IROpfMetadata, IROpfManifest, IROpfSpine;

@interface IREpubBook : NSObject

/** 书名*/
@property (nonatomic, strong) NSString *name;
/** 版本*/
@property (nonatomic, strong) NSString *version;
/** 作者*/
@property (nonatomic, strong) IRAuthor *author;
/** 封面*/
@property (nonatomic, strong) IRResource *bookCoverResource;
/** 目录*/
@property (nonatomic, strong) NSArray<IRTocRefrence *> *tableOfContents;
@property (nonatomic, strong) NSArray<IRTocRefrence *> *flatTableOfContents;

@property (nonatomic, strong) NSString *resourcesBasePath;
@property (nonatomic, strong) IRContainer   *container;
@property (nonatomic, strong) IROpfMetadata *opfMetadata;
@property (nonatomic, strong) IROpfManifest *opfManifest;
@property (nonatomic, strong) IROpfSpine *opfSpine;

@end
