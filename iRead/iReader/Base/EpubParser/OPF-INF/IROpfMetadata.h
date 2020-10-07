//
//  IROpfMetadata.h
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IROpfMetadata : NSObject
/** 书名*/
@property (nonatomic, strong) NSString *title;
/** 作者*/
@property (nonatomic, strong) NSString *creator;
/** 语言*/
@property (nonatomic, strong) NSString *language;
/** 简介*/
@property (nonatomic, strong) NSString *bookDesc;
/** 日期*/
@property (nonatomic, strong) NSString *date;
/** 标示*/
@property (nonatomic, strong) NSString *identifier;
/** 关键词*/
@property (nonatomic, strong) NSMutableArray<NSString *> *subjects;
/** 来源*/
@property (nonatomic, strong) NSString *source;
/** 版权*/
@property (nonatomic, strong) NSString *rights;
/** 封面ID*/
@property (nonatomic, strong) NSString *coverImageId;

@end
