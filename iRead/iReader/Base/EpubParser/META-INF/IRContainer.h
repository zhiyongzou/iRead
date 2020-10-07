//
//  IRContainer.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRMediaType;

@interface IRContainer : NSObject

@property (nonatomic, strong) NSString *fullPath;
@property (nonatomic, strong) IRMediaType *mediaType;

+ (instancetype)containerWithFullPath:(NSString *)fullPath mediaType:(IRMediaType *)mediaType;

@end
