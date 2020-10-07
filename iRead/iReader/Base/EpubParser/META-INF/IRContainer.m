//
//  IRContainer.m
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRContainer.h"

@implementation IRContainer

+ (instancetype)containerWithFullPath:(NSString *)fullPath mediaType:(IRMediaType *)mediaType
{
    IRContainer *container = [[self alloc] init];
    container.fullPath = fullPath;
    container.mediaType = mediaType;
    
    return container;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.fullPath forKey:@"fullPath"];
    [encoder encodeObject:self.mediaType forKey:@"mediaType"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.fullPath = [decoder decodeObjectForKey:@"fullPath"];
        self.mediaType = [decoder decodeObjectForKey:@"mediaType"];
    }
    
    if (self == nil) {
        NSLog(@"IRContainer Could not unarchive");
    }
    
    return self;
}

@end
