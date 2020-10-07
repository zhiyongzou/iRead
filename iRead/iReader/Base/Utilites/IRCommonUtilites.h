//
//  IRCommonUtilites.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifndef IRCommonUtilites_h
#define IRCommonUtilites_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    // 在主线程上同步执行
    void runOnMainThread(void (^block)(void));
    
    // 在主线程上异步执行
    void runOnMainThreadAsync(void (^block)(void));
    
    // 在主线程runloop进入空闲状态时执行
    void runWhenMainThreadIdle(void (^block)(void));
    
#ifdef __cplusplus
}
#endif

#endif
