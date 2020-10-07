//
//  IRSpine.h
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRResource;

@interface IRSpine : NSObject

@property (nonatomic, assign) BOOL linear;
@property (nonatomic, strong) IRResource *resource;

+ (instancetype)spineWithResource:(IRResource *)resource linear:(BOOL)linear;

@end
