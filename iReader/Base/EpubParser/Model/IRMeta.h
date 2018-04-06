//
//  IRMeta.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRMeta : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *metaId;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *refines;

@end
