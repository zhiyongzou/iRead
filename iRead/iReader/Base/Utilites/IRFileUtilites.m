//
//  IRFileUtilites.m
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRFileUtilites.h"

@implementation IRFileUtilites

+ (NSString *)applicationDocumentsDirectory
{
    static NSString *docDir = nil;
    if (!docDir.length) {
        docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return docDir;
}

+ (NSString *)applicationCachesDirectory
{
    static NSString *cacheDir = nil;
    if (!cacheDir.length) {
        cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    }
    return cacheDir;
}

@end
