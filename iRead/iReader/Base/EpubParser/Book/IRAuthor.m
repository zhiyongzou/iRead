//
//  IRAuthor.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRAuthor.h"

@implementation IRAuthor

+ (instancetype)authorWithName:(NSString *)name
{
    IRAuthor *author = [[self alloc] init];
    author.name = name;
    return author;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.fileAs forKey:@"fileAs"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.role = [decoder decodeObjectForKey:@"role"];
        self.fileAs = [decoder decodeObjectForKey:@"fileAs"];
    }
    
    if (self == nil) {
        NSLog(@"IRAuthor Could not unarchive");
    }
    
    return self;
}

@end
