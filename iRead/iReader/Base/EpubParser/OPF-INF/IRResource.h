//
//  IRResource.h
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRMediaType;

@interface IRResource : NSObject

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *href;
/// 资源全路径
@property (nonatomic, strong) NSString *fullHref;

@property (nonatomic, strong) NSString *properties;

@property (nonatomic, strong) IRMediaType *mediaType;

@end
