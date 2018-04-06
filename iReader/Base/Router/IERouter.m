//
//  IERouter.m
//  iOS_Extensions
//
//  Created by zzyong on 2018/1/22.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IERouter.h"
#import <objc/runtime.h>
#import "NSString+Extension.h"

NSString * const IERouterUserInfo          = @"IERouterUserInfo";
NSString * const IERouterHandlerCompletion = @"IERouterHandlerCompletion";

static NSString * const kTarget      = @"target";
static NSString * const kActionUrl   = @"actionurl";
static NSString * const kParamters   = @"paramters";

@interface IERouter ()

@property (nonatomic, strong) NSMutableDictionary *routers;

@end

@implementation IERouter

- (instancetype)init
{
    if (self = [super init]) {
        _routers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - private

- (BOOL)handleURLString:(NSString *)urlStr
               userInfo:(NSDictionary *)userInfo
             completion:(IERouterResultHandler)completion
{
    NSDictionary *params = [urlStr decodeUrlParameters];
    IERouterHandler handle = [[IERouter defaultRouter].routers objectForKey:[params objectForKey:kTarget]];
    
    if (!handle) {
        NSAssert(NO, @"URL is not register");
        return NO;
    } else {
        
        NSMutableDictionary *routerInfo = [[NSMutableDictionary alloc] init];
        
        if (userInfo) {
            [routerInfo setValue:userInfo forKey:IERouterUserInfo];
        }
        
        if (completion) {
            [routerInfo setValue:completion forKey:IERouterHandlerCompletion];
        }
        
        handle(routerInfo);
    }
    
    return YES;
}

+ (BOOL)isValidWithPropertyName:(NSString *)name value:(id)value inClass:(Class)clz
{
    objc_property_t property = class_getProperty(clz, [name UTF8String]);
    if (property == NULL) {
        return NO;
    }
    
    unsigned int attrCount = 0;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);// "Ti,N,V_propertyName"
    if (attrCount == 0) {
        return NO;
    }
    
    for (int i = 0; i < attrCount; ++ i) {
        switch (attrs[i].name[0]) {
            case 'T':
            {
                NSString *propertyType = [NSString stringWithUTF8String:attrs[i].value];
                return [self isValidWithPropertyType:propertyType value:value];
                break;
            }
            default:
                break;
        }
    }
    return NO;
}

+ (BOOL)isValidWithPropertyType:(NSString *)propertyType value:(id)value
{
    // 如果是字符串，会传进 \"NSString"，需要转换为 NSString
    if ([propertyType hasPrefix:@"@"]) {
        NSString *typeName = [propertyType substringFromIndex:1];
        typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([value isKindOfClass:NSClassFromString(typeName)]) {
            return YES;
        } else if ([typeName hasPrefix:@"?"]) {
            // Block
            if ([value isKindOfClass:NSClassFromString(@"NSBlock")]) {
                return YES;
            }
        } else if ([typeName hasPrefix:@"<"] && [typeName hasSuffix:@">"]) {
            //Protocol
            typeName = [typeName stringByReplacingOccurrencesOfString:@"<" withString:@""];
            typeName = [typeName stringByReplacingOccurrencesOfString:@">" withString:@""];
            
            Protocol *protocol = NSProtocolFromString(typeName);
            
            if (protocol && [value conformsToProtocol:protocol]) {
                return YES;
            }
        }
        
#ifdef DEBUG
        NSLog(@"%s, [ERROR]: propertyType: %@, typeName: %@, but valueClass: %@", __func__, propertyType, typeName, NSStringFromClass([value class]));
#endif
        
    } else {
        // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        if ([value isKindOfClass:[NSNumber class]]) {
            static NSArray *numberTypes = nil;
            if (!numberTypes) {
                numberTypes = @[@"c", @"i", @"s", @"l", @"l", @"q", @"C", @"I", @"S", @"L", @"Q", @"f", @"d", @"B"];
            }
            
            if ([numberTypes containsObject:propertyType]) {
                return YES;
            }
        }
        
        const char *valueType = [value respondsToSelector:@selector(objCType)] ? [value objCType] : [NSStringFromClass([value class]) UTF8String];
        if ([[NSString stringWithUTF8String:valueType] isEqualToString:propertyType]) {
            return YES;
        }
        
#ifdef DEBUG
        NSLog(@"%s, [ERROR]: propertyType: %@ valueType: %@", __func__, propertyType, [NSString stringWithUTF8String:valueType]);
#endif
        
    }
    return NO;
}


#pragma mark - public

+ (void)registerRoutersWithPlistName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    
    if (!path) {
        NSAssert(NO, @"%s %@", __func__, [NSString stringWithFormat:@"%@.plist is not exist", name]);
        return;
    }
    
    NSArray<NSDictionary *> *routers = [NSArray arrayWithContentsOfFile:path];
    
    [routers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj[kTarget]) {
            NSArray *initInfos = obj[kParamters];
            Class target = NSClassFromString(obj[kTarget]);
            if (target) {
                [IERouter registerTargetStr:obj[kActionUrl] toHandler:^(NSDictionary *routerInfo) {
                    IERouterResultHandler handler = routerInfo[IERouterHandlerCompletion];
                    if (handler) {
                        handler(target, initInfos);
                    }
                }];
            } else {
                NSAssert(NO, @"%s %@", __func__, [NSString stringWithFormat:@"NSClassFromString: %@ return Nil", name]);
            }
        }
    }];
}

+ (void)registerTargetStr:(NSString *)targetStr toHandler:(IERouterHandler)handler
{
    if ([[[self defaultRouter] routers] objectForKey:targetStr]) {
        return;
    }
    
    if (targetStr.length > 0 && handler != nil) {
        [[[self defaultRouter] routers] setValue:handler forKey:targetStr];
    }
}

- (void)unregisterTargetStr:(NSString *)targetStr
{
    if (targetStr.length > 0) {
        [_routers removeObjectForKey:targetStr];
    }
}

+ (BOOL)openURLString:(NSString *)urlStr context:(RouterOpenContext *)context
{
    UIViewController *currentVc = context.fromViewController;
    if (!currentVc) {
        NSAssert(NO, @"kOpenContextCurrentViewController is null");
        return NO;
    }
    
    IERouterResultHandler handler = ^(__unsafe_unretained Class target, NSArray *initInfos) {
        
        id targetObj = [[target alloc] init];
        
        NSMutableDictionary *params = [context.userInfo mutableCopy];
        NSMutableDictionary *urlParamss = [[urlStr decodeUrlParameters] mutableCopy];
        
        if (urlParamss) {
            [urlParamss removeObjectForKey:kTarget];
            
            if (!params) {
                params = [NSMutableDictionary dictionary];
            }
            [params addEntriesFromDictionary:urlParamss];
        }
        
        if (targetObj && [targetObj isKindOfClass:[UIViewController class]]) {
            
            for (NSString *key in params.allKeys) {
                id value = params[key];
                if ([self isValidWithPropertyName:key value:value inClass:target]) {
                    [targetObj setValue:value forKeyPath:key];
                } else {
                    NSAssert(NO, @"%s %@", __func__, [NSString stringWithFormat:@"failed to setValue: %@ forKey: %@", value, key]);
                }
            }
            
            if (context.transitionType == TransitionTypePush) {
                [currentVc.navigationController pushViewController:targetObj animated:YES];
            } else {
                [currentVc presentViewController:targetObj animated:YES completion:nil];
            }
        } else {
            NSAssert(NO, @"target is not ViewController");
        }
    };
    
    return [[self defaultRouter] handleURLString:urlStr
                                        userInfo:context.userInfo
                                      completion:handler];
}

+ (RouterOpenContext *)openContextWithUserInfo:(NSDictionary *)userInfo
                            fromViewController:(UIViewController *)vc
                                transitionType:(TransitionType)type
                                      animated:(BOOL)flag
{
    RouterOpenContext *context = [[RouterOpenContext alloc] init];
    
    context.fromViewController = vc;
    context.userInfo = userInfo;
    context.transitionType = type;
    context.transitionAnimated = flag;
    
    return context;
}

+ (instancetype)defaultRouter
{
    static IERouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

@end

@implementation RouterOpenContext

@end
