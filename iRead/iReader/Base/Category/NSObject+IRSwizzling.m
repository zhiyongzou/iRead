//
//  NSObject+IRSwizzling.m
//  iReader
//
//  Created by zzyong on 2018/8/16.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "NSObject+IRSwizzling.h"
#import <objc/runtime.h>

#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)    \
if (ERROR_VAR) {    \
    NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
    *ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
                                     code:-1    \
                                 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}

#define SetNSError(ERROR_VAR, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)

@implementation NSObject (IR_Swizzling)

+ (BOOL)ir_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error
{
    Method origMethod = class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        SetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        SetNSError(error, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return  NO;
    }
    
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel), class_getInstanceMethod(self, altSel));
    
    return YES;
}

+ (BOOL)ir_swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel error:(NSError**)error
{
    return [object_getClass((id)self) ir_swizzleMethod:origSel withMethod:altSel error:error];
}

- (BOOL)ir_setClass:(Class)altClass error:(NSError**)error
{
    if (class_getInstanceSize([self class]) == class_getInstanceSize(altClass)) {
        object_setClass(self, altClass);
        return YES;
    } else {
        SetNSError(error, @"classes must be same size to swizzle. original: %@ alternate: %@" , NSStringFromClass(altClass), NSStringFromClass([self class]));
        return NO;
    }
}


@end
