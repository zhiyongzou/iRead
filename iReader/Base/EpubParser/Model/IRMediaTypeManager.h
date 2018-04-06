//
//  IRMediaTypeManager.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRMediaType;

@interface IRMediaTypeManager : NSObject

@property (nonatomic, strong, readonly) NSArray<IRMediaType *> *mediaTypes;

+ (instancetype)sharedManager;

- (IRMediaType *)mediaTypeByName:(NSString *)name fileName:(NSString *)fileName;

- (BOOL)isBitmapImage:(IRMediaType *)mediaType;

- (IRMediaType *)determineMediaTypeByFileName:(NSString *)fileName;

@end
