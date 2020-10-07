//
//  IRCacheManager.h
//  iReader
//
//  Created by zzyong on 2018/8/24.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IR_CACHE_MANAGER [IRCacheManager sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface IRCacheManager : NSObject

+ (instancetype)sharedInstance;

- (void)setObject:(_Nonnull id)value forKey:(_Nonnull id)key;
- (void)asyncSetObject:(_Nonnull id)value forKey:(_Nonnull id)key;

- (void)removeObjectForKey:(_Nonnull id)key;
- (void)asyncRemoveObjectForKey:(_Nonnull id)key;

- (nullable id)objectForKey:(_Nonnull id)key;
- (void)asyncObjectForKey:(_Nonnull id)key completion:(void (^)(_Nullable id value, id key))completion;

@end

NS_ASSUME_NONNULL_END
