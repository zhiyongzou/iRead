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

#pragma mark - public

- (BOOL)isBitmapImage
{
    return [self.defaultExtension isEqualToString:@"jpg"] ||
           [self.defaultExtension isEqualToString:@"png"] ||
           [self.defaultExtension isEqualToString:@"gif"];
}

+ (instancetype)mediaTypeWithName:(NSString *)name fileName:(NSString *)fileName
{
    static NSString *const kXhtmlMediaType = @"application/xhtml+xml";
    static NSString *const kEpubMediaType  = @"application/epub+zip";
    static NSString *const kNcxMediaType   = @"application/x-dtbncx+xml";
    static NSString *const kOpfMediaType   = @"application/oebps-package+xml";
    static NSString *const kCSStMediaType  = @"text/css";
    static NSString *const kJpgMediaType   = @"image/jpeg";
    static NSString *const kPNGMediaType   = @"image/png";
    static NSString *const kGIFMediaType   = @"image/gif";
    static NSString *const kSVGMediaType   = @"image/svg+xml";
    static NSString *const kTTFMediaType   = @"application/x-font-ttf";
    static NSString *const kTTF1MediaType  = @"application/x-font-truetype";
    static NSString *const kTTF2MediaType  = @"application/x-truetype-font";
    static NSString *const kWoffMediaType  = @"application/font-woff";
    static NSString *const kMp3MediaType   = @"audio/mpeg";
    static NSString *const kMp4MediaType   = @"audio/mp4";
    static NSString *const kOggMediaType   = @"audio/ogg";
    static NSString *const kSmilMediaType  = @"application/smil+xml";
    static NSString *const kXpgtMediaType  = @"application/adobe-page-template+xml";
    static NSString *const kPlsMediaType   = @"application/pls+xml";
    
    static NSString *const kJavascriptMediaType = @"text/javascript";
    static NSString *const kOpenTypeMediaType   = @"application/vnd.ms-opentype";
    
    if ([kXhtmlMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kXhtmlMediaType
                                defaultExtension:@"xhtml"
                                      extensions:@[@"htm", @"html", @"xhtml", @"xml"]];
        
    } else if ([kEpubMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kEpubMediaType
                                defaultExtension:@"epub"
                                      extensions:nil];
        
    } else if ([kNcxMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kNcxMediaType
                                defaultExtension:@"ncx"
                                      extensions:nil];
        
    } else if ([kOpfMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kOpfMediaType
                                defaultExtension:@"opf"
                                      extensions:nil];
        
    } else if ([kJavascriptMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kJavascriptMediaType
                                defaultExtension:@"js"
                                      extensions:nil];
        
    } else if ([kCSStMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kCSStMediaType
                                defaultExtension:@"css"
                                      extensions:nil];
        
    } else if ([kJpgMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kJpgMediaType
                                defaultExtension:@"jpg"
                                      extensions:@[@"jpg", @ "jpeg"]];
        
    } else if ([kPNGMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kPNGMediaType
                                defaultExtension:@"png"
                                      extensions:nil];
        
    } else if ([kGIFMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kGIFMediaType
                                defaultExtension:@"gif"
                                      extensions:nil];
        
    } else if ([kSVGMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kSVGMediaType
                                defaultExtension:@"svg"
                                      extensions:nil];
        
    } else if ([kTTFMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kTTFMediaType
                                defaultExtension:@"ttf"
                                      extensions:nil];
        
    } else if ([kTTF1MediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kTTF1MediaType
                                defaultExtension:@"ttf"
                                      extensions:nil];
        
    } else if ([kTTF2MediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kTTF2MediaType
                                defaultExtension:@"ttf"
                                      extensions:nil];
        
    } else if ([kOpenTypeMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kOpenTypeMediaType
                                defaultExtension:@"otf"
                                      extensions:nil];
        
    } else if ([kWoffMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kWoffMediaType
                                defaultExtension:@"woff"
                                      extensions:nil];
        
    } else if ([kMp3MediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kMp3MediaType
                                defaultExtension:@"mp3"
                                      extensions:nil];
        
    } else if ([kMp4MediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kMp4MediaType
                                defaultExtension:@"mp4"
                                      extensions:nil];
        
    } else if ([kOggMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kOggMediaType
                                defaultExtension:@"ogg"
                                      extensions:nil];
        
    } else if ([kSmilMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kSmilMediaType
                                defaultExtension:@"smil"
                                      extensions:nil];
        
    } else if ([kXpgtMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kXpgtMediaType
                                defaultExtension:@"xpgt"
                                      extensions:nil];
        
    } else if ([kPlsMediaType isEqualToString:name]) {
        return [[IRMediaType alloc] initWithName:kPlsMediaType
                                defaultExtension:@"pls"
                                      extensions:nil];
        
    } else {
        return [[IRMediaType alloc] initWithName:name
                                defaultExtension:fileName.pathExtension
                                      extensions:nil];
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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.defaultExtension forKey:@"defaultExtension"];
    [encoder encodeObject:self.extensions forKey:@"extensions"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.defaultExtension = [decoder decodeObjectForKey:@"defaultExtension"];
        self.extensions = [decoder decodeObjectForKey:@"extensions"];
    }
    
    if (self == nil) {
        NSLog(@"IRMediaType Could not unarchive");
    }
    
    return self;
}

@end
