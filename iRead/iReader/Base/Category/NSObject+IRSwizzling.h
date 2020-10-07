//
//  NSObject+IRSwizzling.h
//  iReader
//
//  Created by zzyong on 2018/8/16.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IR_Swizzling)

//method swizzling
+ (BOOL)ir_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error;
+ (BOOL)ir_swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel error:(NSError**)error;

//isa swizzling
- (BOOL)ir_setClass:(Class)altClass error:(NSError**)error;

@end
