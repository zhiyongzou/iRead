//
//  IRUIUtilites.m
//  iReader
//
//  Created by zzyong on 2018/8/7.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRUIUtilites.h"

@implementation IRUIUtilites

+ (UIColor *)appThemeColor
{
    static UIColor *appThemeColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appThemeColor = [UIColor ir_colorWithRed:255 green:156 blue:0];
    });
    
    return appThemeColor;
}

+ (CGFloat)appStatusBarMaxY
{
    static CGFloat appStatusBarMaxY;
    if (!appStatusBarMaxY) {
        appStatusBarMaxY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    }
    
    return appStatusBarMaxY;
}

+ (CGFloat)UIScreenMinWidth
{
    static CGFloat UIScreenMinWidth;
    if (!UIScreenMinWidth) {
        UIScreenMinWidth = MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    
    return UIScreenMinWidth;
}

+ (CGFloat)UIScreenMaxHeight
{
    static CGFloat UIScreenMaxHeight;
    if (!UIScreenMaxHeight) {
        UIScreenMaxHeight = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    
    return UIScreenMaxHeight;
}

+ (BOOL)isIPhoneXSeries
{
    return isIPhoneXSeries();
}

static inline BOOL isIPhoneXSeries()
{
    static BOOL iPhoneXSeries = NO;
    
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            if ((mainWindow.safeAreaInsets.top > 0.0 && mainWindow.safeAreaInsets.bottom > 0.0) ||
                (mainWindow.safeAreaInsets.left > 0.0 && mainWindow.safeAreaInsets.right > 0.0)) {
                iPhoneXSeries = YES;
            }
        }
    });
    
    return iPhoneXSeries;
}

+ (UIEdgeInsets)safeEdgeInsets
{
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

@end
