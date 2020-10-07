//
//  NSDictionary+Safe.m
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (IR_Safe)

- (id)safeObjectForKey:(id)aKey
{
#ifdef DEBUG
    return [self objectForKey:aKey];
#else
    if (aKey) {
       return [self objectForKey:aKey];
    }
    return nil;
#endif
}

@end

@implementation NSMutableDictionary (IR_Safe)

- (void)safeRemoveObjectForKey:(id)aKey
{
#ifdef DEBUG
    [self removeObjectForKey:aKey];
#else
    if (aKey) {
        [self removeObjectForKey:aKey];
    }
#endif
}

- (void)safeSetObject:(id)anObject forKey:(id)aKey
{
#ifdef DEBUG
        [self setObject:anObject forKey:aKey];
#else
        if (aKey && anObject) {
            [self setObject:anObject forKey:aKey];
        }
#endif
}

@end
