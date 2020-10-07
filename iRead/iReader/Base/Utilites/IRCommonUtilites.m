//
//  IRCommonUtilites.m
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRCommonUtilites.h"

void _runOnMainThread(void (^block)(void), BOOL async)
{
    if ([[NSThread currentThread] isMainThread]) {
        block();
    } else if (async) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void runOnMainThread(void (^block)(void))
{
    _runOnMainThread(block, NO);
}

void runOnMainThreadAsync(void (^block)(void))
{
    _runOnMainThread(block, YES);
}

void runWhenMainThreadIdle(void (^block)(void))
{
    if (@available(iOS 10.0, *)) {
        dispatch_assert_queue(dispatch_get_main_queue());
    }
    
    CFRunLoopActivity flags = kCFRunLoopBeforeWaiting;
    __block CFRunLoopObserverRef runloopObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, flags, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (block) {
            block();
        }
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), runloopObserver, kCFRunLoopDefaultMode);
        CFRelease(runloopObserver);
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), runloopObserver, kCFRunLoopDefaultMode);
}


