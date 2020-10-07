//
//  AppDelegate+Debug.m
//  iReader
//
//  Created by zzyong on 2018/10/8.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "AppDelegate+Debug.h"
#import <FLEX.h>
#import "IRDebugConst.h"
#import "DTCoreTextLayoutFrame.h"

static UIWindow *flexWindow;

@implementation AppDelegate (Debug)

- (void)debugInit
{
    [self addFLEX];
    
    BOOL dtEndble = [[[IRCacheManager sharedInstance] objectForKey:kDTCoreTextDebugEnableCacheKey] boolValue];
    [DTCoreTextLayoutFrame setShouldDrawDebugFrames:dtEndble];
}

- (UIWindow *)flexWindow
{
    return flexWindow;
}

- (void)addFLEX
{
    flexWindow = [[UIWindow alloc] init];
    flexWindow.backgroundColor = [UIColor clearColor];
    flexWindow.rootViewController = [[UIViewController alloc] init];
    flexWindow.windowLevel = UIWindowLevelStatusBar + 50;
    CGFloat windowY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    flexWindow.frame = CGRectMake(0.5 * ([UIScreen mainScreen].bounds.size.width - 30), windowY, 30, 13);
    [flexWindow makeKeyAndVisible];
    
    UIButton *flexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flexBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [flexBtn setTitle:@"FLEX" forState:UIControlStateNormal];
    [flexBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [flexBtn addTarget:self action:@selector(showFlexSettingView) forControlEvents:UIControlEventTouchUpInside];
    flexBtn.frame = flexWindow.bounds;
    [flexWindow addSubview:flexBtn];
    
    flexWindow.hidden = [[[IRCacheManager sharedInstance] objectForKey:kFlexDebugDisableCacheKey] boolValue];
}

-(void)showFlexSettingView
{
    [[FLEXManager sharedManager] showExplorer];
}

@end

