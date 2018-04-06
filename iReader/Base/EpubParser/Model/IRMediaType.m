//
//  IRMediaType.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRMediaType.h"

@implementation IRMediaType

- (NSUInteger)hash
{
    return self.name.hash ^ self.defaultExtension.hash ^ self.extensions.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        return [self.name isEqualToString:[(IRMediaType *)object name]] &&
        [self.defaultExtension isEqualToString:[(IRMediaType *)object defaultExtension]] &&
        [self.extensions isEqualToArray:[(IRMediaType *)object extensions]];
    } else {
        return [super isEqual:object];
    }
}

- (instancetype)initWithName:(NSString *)name
            defaultExtension:(NSString *)defaultExtension
                  extensions:(NSArray<NSString *> *)extensions
{
    if (self = [super init]) {
        self.name = name;
        self.defaultExtension = defaultExtension;
        self.extensions = extensions;
    }
    return self;
}

@end
