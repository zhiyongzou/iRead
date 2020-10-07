//
//  IRSpine.m
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSpine.h"

@implementation IRSpine

+ (instancetype)spineWithResource:(IRResource *)resource linear:(BOOL)linear
{
    IRSpine *spine = [[self alloc] init];
    spine.resource = resource;
    spine.linear = linear;
    
    return spine;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:self.linear forKey:@"linear"];
    [encoder encodeObject:self.resource forKey:@"resource"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.linear = [decoder decodeBoolForKey:@"linear"];
        self.resource = [decoder decodeObjectForKey:@"resource"];
    }
    
    if (self == nil) {
        NSLog(@"IRSpine Could not unarchive");
    }
    
    return self;
}

@end
