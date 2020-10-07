//
//  IRTocRefrence.m
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRTocRefrence.h"

@implementation IRTocRefrence

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.childen forKey:@"childen"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.resource forKey:@"resource"];
    [encoder encodeObject:self.fragmentId forKey:@"fragmentId"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.childen = [decoder decodeObjectForKey:@"childen"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.resource = [decoder decodeObjectForKey:@"resource"];
        self.fragmentId = [decoder decodeObjectForKey:@"fragmentId"];
    }
    
    if (self == nil) {
        NSLog(@"IRTocRefrence Could not unarchive");
    }
    
    return self;
}

@end
