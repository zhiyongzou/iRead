//
//  IROpfSpine.m
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IROpfSpine.h"

@implementation IROpfSpine

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:self.spineReferences forKey:@"spineReferences"];
    [encoder encodeObject:self.pageProgressionDirection forKey:@"pageProgressionDirection"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.spineReferences = [decoder decodeObjectForKey:@"spineReferences"];
        self.pageProgressionDirection = [decoder decodeObjectForKey:@"pageProgressionDirection"];
    }
    
    if (self == nil) {
        NSLog(@"IROpfSpine Could not unarchive");
    }
    
    return self;
}

@end
