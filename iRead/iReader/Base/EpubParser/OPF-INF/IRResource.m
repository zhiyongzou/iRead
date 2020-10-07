//
//  IRResource.m
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRResource.h"

@implementation IRResource

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.itemId forKey:@"itemId"];
    [encoder encodeObject:self.href forKey:@"href"];
    [encoder encodeObject:self.fullHref forKey:@"fullHref"];
    [encoder encodeObject:self.properties forKey:@"properties"];
    [encoder encodeObject:self.mediaType forKey:@"mediaType"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.itemId = [decoder decodeObjectForKey:@"itemId"];
        self.href = [decoder decodeObjectForKey:@"href"];
        self.fullHref = [decoder decodeObjectForKey:@"fullHref"];
        self.properties = [decoder decodeObjectForKey:@"properties"];
        self.mediaType = [decoder decodeObjectForKey:@"mediaType"];
    }
    
    if (self == nil) {
        NSLog(@"IRResource Could not unarchive");
    }
    
    return self;
}

@end
