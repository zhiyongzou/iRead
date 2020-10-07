//
//  IREpubBook.m
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IREpubBook.h"

@implementation IREpubBook

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.version forKey:@"version"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.bookCoverResource forKey:@"bookCoverResource"];
    [encoder encodeObject:self.tableOfContents forKey:@"tableOfContents"];
    [encoder encodeObject:self.flatTableOfContents forKey:@"flatTableOfContents"];
    [encoder encodeObject:self.resourcesBasePath forKey:@"resourcesBasePath"];
    [encoder encodeObject:self.container forKey:@"container"];
    [encoder encodeObject:self.opfMetadata forKey:@"opfMetadata"];
    [encoder encodeObject:self.opfManifest forKey:@"opfManifest"];
    [encoder encodeObject:self.opfSpine forKey:@"opfSpine"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.version = [decoder decodeObjectForKey:@"version"];
        self.author = [decoder decodeObjectForKey:@"author"];
        self.bookCoverResource = [decoder decodeObjectForKey:@"bookCoverResource"];
        self.tableOfContents = [decoder decodeObjectForKey:@"tableOfContents"];
        self.flatTableOfContents = [decoder decodeObjectForKey:@"flatTableOfContents"];
        self.resourcesBasePath = [decoder decodeObjectForKey:@"resourcesBasePath"];
        self.container = [decoder decodeObjectForKey:@"container"];
        self.opfMetadata = [decoder decodeObjectForKey:@"opfMetadata"];
        self.opfManifest = [decoder decodeObjectForKey:@"opfManifest"];
        self.opfSpine = [decoder decodeObjectForKey:@"opfSpine"];
    }
    
    if (self == nil) {
        NSLog(@"IREpubBook Could not unarchive");
    }
    
    return self;
}

@end
