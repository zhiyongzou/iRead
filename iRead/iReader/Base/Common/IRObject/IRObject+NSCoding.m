//
//  IRObject+NSCoding.m
//  iReader
//
//  Created by zzyong on 2018/9/18.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject+NSCoding.h"

@implementation IRObject (NSCoding)

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    for (NSString *key in self.class.propertyKeys) {
        id value = [decoder decodeObjectForKey:key];
        if (!value) {
            continue;
        }
        [self setValue:value forKeyPath:key];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    for (NSString *key in self.class.propertyKeys) {
        id value = [self valueForKeyPath:key];
        if (!value) {
            continue;
        }
        [encoder encodeObject:value forKey:key];
    }
}

- (nullable id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key
{
    // do nothing
    NSAssert(NO, @"Class:%@ undefined key:%@", NSStringFromClass([self class]), key);
}

@end
