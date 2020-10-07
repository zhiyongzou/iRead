//
//  IROpfSpine.h
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRSpine;

@interface IROpfSpine : NSObject

@property (nonatomic, strong) NSArray<IRSpine *> *spineReferences;
@property (nonatomic, strong) NSString *pageProgressionDirection;

@end
