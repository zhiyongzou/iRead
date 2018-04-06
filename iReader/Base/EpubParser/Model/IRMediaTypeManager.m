//
//  IRMediaTypeManager.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRMediaTypeManager.h"
#import "IRMediaType.h"

@implementation IRMediaTypeManager

+ (instancetype)sharedManager
{
    static IRMediaTypeManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupMediaTypes];
    }
    
    return self;
}

- (void)setupMediaTypes
{
    IRMediaType *xhtml = [[IRMediaType alloc] initWithName:@"application/xhtml+xml" defaultExtension:@"xhtml" extensions:@[@"htm", @"html", @"xhtml", @"xml"]];
    IRMediaType *epub = [[IRMediaType alloc] initWithName:@"application/epub+zip" defaultExtension:@"epub" extensions:nil];
    IRMediaType *ncx = [[IRMediaType alloc] initWithName:@"application/x-dtbncx+xml" defaultExtension:@"ncx" extensions:nil];
    IRMediaType *opf = [[IRMediaType alloc] initWithName:@"application/oebps-package+xml" defaultExtension:@"opf" extensions:nil];
    IRMediaType *javaScript = [[IRMediaType alloc] initWithName:@"text/javascript" defaultExtension:@"js" extensions:nil];
    IRMediaType *css = [[IRMediaType alloc] initWithName:@"text/css" defaultExtension:@"css" extensions:nil];
   
    // images
    IRMediaType *jpg = [[IRMediaType alloc] initWithName:@"image/jpeg" defaultExtension:@"jpg" extensions:@[@"jpg", @ "jpeg"]];
    IRMediaType *png = [[IRMediaType alloc] initWithName:@"image/png" defaultExtension:@"png" extensions:nil];
    IRMediaType *gif = [[IRMediaType alloc] initWithName:@"image/gif" defaultExtension:@"gif" extensions:nil];
    IRMediaType *svg = [[IRMediaType alloc] initWithName:@"image/svg+xml" defaultExtension:@"svg" extensions:nil];
    
    // fonts
    IRMediaType *ttf = [[IRMediaType alloc] initWithName:@"application/x-font-ttf" defaultExtension:@"ttf" extensions:nil];
    IRMediaType *ttf1 = [[IRMediaType alloc] initWithName:@"application/x-font-truetype" defaultExtension:@"ttf" extensions:nil];
    IRMediaType *ttf2 = [[IRMediaType alloc] initWithName:@"application/x-truetype-font" defaultExtension:@"ttf" extensions:nil];
    IRMediaType *openType = [[IRMediaType alloc] initWithName:@"application/vnd.ms-opentype" defaultExtension:@"otf" extensions:nil];
    IRMediaType *woff = [[IRMediaType alloc] initWithName:@"application/font-woff" defaultExtension:@"woff" extensions:nil];
    
    // audio
    IRMediaType *mp3 = [[IRMediaType alloc] initWithName:@"audio/mpeg" defaultExtension:@"mp3" extensions:nil];
    IRMediaType *mp4 = [[IRMediaType alloc] initWithName:@"audio/mp4" defaultExtension:@"mp4" extensions:nil];
    IRMediaType *ogg = [[IRMediaType alloc] initWithName:@"audio/ogg" defaultExtension:@"ogg" extensions:nil];
    
    IRMediaType *smil = [[IRMediaType alloc] initWithName:@"application/smil+xml" defaultExtension:@"smil" extensions:nil];
    IRMediaType *xpgt = [[IRMediaType alloc] initWithName:@"application/adobe-page-template+xml" defaultExtension:@"xpgt" extensions:nil];
    IRMediaType *pls = [[IRMediaType alloc] initWithName:@"application/pls+xml" defaultExtension:@"pls" extensions:nil];
    
    _mediaTypes = @[xhtml, epub, ncx, opf, jpg, png, gif, javaScript, css, svg, ttf, ttf1, ttf2, openType, woff, mp3, mp4, ogg, smil, xpgt, pls];
}

- (IRMediaType *)mediaTypeByName:(NSString *)name fileName:(NSString *)fileName
{
    IRMediaType *mediatype = nil;
    for (IRMediaType *tempMediatype in _mediaTypes) {
        if ([tempMediatype.name isEqualToString:name]) {
            mediatype = tempMediatype;
            break;
        }
    }
    
    if (!mediatype) {
        NSString *ext = fileName.pathExtension ?: @"";
        mediatype = [[IRMediaType alloc] initWithName:name defaultExtension:ext extensions:nil];
    }
    
    return mediatype;
}

- (BOOL)isBitmapImage:(IRMediaType *)mediaType
{
    return [mediaType.defaultExtension isEqualToString:@"jpg"] ||
           [mediaType.defaultExtension isEqualToString:@"png"] ||
           [mediaType.defaultExtension isEqualToString:@"gif"];
}

- (IRMediaType *)determineMediaTypeByFileName:(NSString *)fileName
{
    NSString *ext = fileName.pathExtension;
    IRMediaType *mediatype = nil;
    
    for(IRMediaType *tempMediatype in _mediaTypes) {
        if([tempMediatype.defaultExtension isEqualToString:ext]) {
            mediatype = tempMediatype;
            break;
        }
        
        if ([tempMediatype.extensions containsObject:ext]) {
            mediatype = tempMediatype;
            break;
        }
    }
    
    return mediatype;
}

@end
