//
//  IRCommonDefines.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifndef IRCommonDefines_h
#define IRCommonDefines_h

#pragma mark - SystemVersion

#define IsOverThanOrEqualToiOS8      ([[[UIDevice currentDevice] systemVersion] intValue] >= 8)
#define IsOverThanOrEqualToiOS9      ([[[UIDevice currentDevice] systemVersion] intValue] >= 9)
#define IsOverThanOrEqualToiOS10     ([[[UIDevice currentDevice] systemVersion] intValue] >= 10)
#define IsOverThanOrEqualToiOS11     ([[[UIDevice currentDevice] systemVersion] intValue] >= 11)

#pragma mark - Custom Debug Log

#ifdef DEBUG
#define IRDebugLog(fmt, ...) NSLog((@"%s %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define IRDebugLog(fmt, ...)
#endif

#pragma mark -

#define IR_WEAK_SELF __weak typeof(self) weakSelf = self;

#endif /* IRCommonDefines_h */
