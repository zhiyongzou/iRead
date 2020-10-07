//
//  IRTocRefrence.h
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRResource;

@interface IRTocRefrence : NSObject

@property (nonatomic, strong) NSArray<IRTocRefrence *> *childen;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) IRResource *resource;
@property (nonatomic, strong) NSString *fragmentId;


@end
