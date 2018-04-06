//
//  IREpubMetadata.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRAuthor, IRMeta, IREventDate, IRIndetifier;

@interface IREpubMetadata : NSObject

@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSArray<IRAuthor *> *creators;
@property (nonatomic, strong) NSArray<IRAuthor *> *contributors;
@property (nonatomic, strong) NSArray<IREventDate *> *dates;
@property (nonatomic, strong) NSArray<IRMeta *> *metaAttributes;
@property (nonatomic, strong) NSArray<IRIndetifier *> *indetifiers;
@property (nonatomic, strong) NSArray<NSString *> *rights;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSString *> *subjects;
@property (nonatomic, strong) NSArray<NSString *> *descriptions;
@property (nonatomic, strong) NSArray<NSString *> *publishers;

@end
