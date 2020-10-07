//
//  IROpfMetadata.m
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IROpfMetadata.h"

@implementation IROpfMetadata

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.creator forKey:@"creator"];
    [encoder encodeObject:self.language forKey:@"language"];
    [encoder encodeObject:self.bookDesc forKey:@"bookDesc"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.subjects forKey:@"subjects"];
    [encoder encodeObject:self.source forKey:@"source"];
    [encoder encodeObject:self.rights forKey:@"rights"];
    [encoder encodeObject:self.coverImageId forKey:@"coverImageId"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.creator = [decoder decodeObjectForKey:@"creator"];
        self.language = [decoder decodeObjectForKey:@"language"];
        self.bookDesc = [decoder decodeObjectForKey:@"bookDesc"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.identifier = [decoder decodeObjectForKey:@"identifier"];
        self.subjects = [decoder decodeObjectForKey:@"subjects"];
        self.source = [decoder decodeObjectForKey:@"source"];
        self.rights = [decoder decodeObjectForKey:@"rights"];
        self.coverImageId = [decoder decodeObjectForKey:@"coverImageId"];
    }
    
    if (self == nil) {
        NSLog(@"IROpfMetadata Could not unarchive");
    }
    
    return self;
}

@end
