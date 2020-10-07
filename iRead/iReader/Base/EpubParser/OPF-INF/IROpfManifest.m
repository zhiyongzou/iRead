//
//  IROpfManifest.m
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IROpfManifest.h"

@implementation IROpfManifest

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.resources forKey:@"resources"];
    [encoder encodeObject:self.cssResources forKey:@"cssResources"];
    [encoder encodeObject:self.coverImageResource forKey:@"coverImageResource"];
    [encoder encodeObject:self.tocNCXResource forKey:@"tocNCXResource"];
    [encoder encodeObject:self.htmlNCXResource forKey:@"htmlNCXResource"];
    [encoder encodeObject:self.manifestOfHrefs forKey:@"manifestOfHrefs"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.resources = [decoder decodeObjectForKey:@"resources"];
        self.cssResources = [decoder decodeObjectForKey:@"cssResources"];
        self.coverImageResource = [decoder decodeObjectForKey:@"coverImageResource"];
        self.tocNCXResource = [decoder decodeObjectForKey:@"tocNCXResource"];
        self.htmlNCXResource = [decoder decodeObjectForKey:@"htmlNCXResource"];
        self.manifestOfHrefs = [decoder decodeObjectForKey:@"manifestOfHrefs"];
    }
    
    if (self == nil) {
        NSLog(@"IROpfManifest Could not unarchive");
    }
    
    return self;
}

@end
