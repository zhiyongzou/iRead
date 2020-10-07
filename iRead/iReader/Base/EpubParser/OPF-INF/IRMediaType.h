//
//  IRMediaType.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRMediaType : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *defaultExtension;
@property (nonatomic, strong) NSArray<NSString *> *extensions;

+ (instancetype)mediaTypeWithName:(NSString *)name fileName:(NSString *)fileName;

- (BOOL)isBitmapImage;

- (instancetype)initWithName:(NSString *)name
            defaultExtension:(NSString *)defaultExtension
                  extensions:(NSArray<NSString *> *)extensions;

@end
