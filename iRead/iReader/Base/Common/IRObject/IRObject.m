//
//  IRObject.m
//  iReader
//
//  Created by zzyong on 2018/9/18.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject.h"
#import "IRObject+NSCoding.h"
#import <objc/runtime.h>

static void *IRModelCachedPropertyKeysKey = &IRModelCachedPropertyKeysKey;

@implementation IRObject

+ (NSSet *)propertyKeys
{
    NSSet *cachedKeys = objc_getAssociatedObject(self, IRModelCachedPropertyKeysKey);
    if (cachedKeys) {
        return cachedKeys;
    }
    
    NSMutableSet *keys = [NSMutableSet set];
    
    [self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
        
        if ([self propertyIsReadonly:property]) {
            return;
        }
        
        NSString *key = @(property_getName(property));
        [keys addObject:key];
    }];
    
    objc_setAssociatedObject(self, IRModelCachedPropertyKeysKey, keys, OBJC_ASSOCIATION_COPY);
    
#ifdef DEBUG
    NSLog(@"Class:[%@] property keys: %@", NSStringFromClass([self class]), keys);
#endif
    
    return keys;
}

#pragma mark -

+ (BOOL)propertyIsReadonly:(objc_property_t)property
{
    const char * const attrCString = property_getAttributes(property);
    if (!attrCString) {
#ifdef DEBUG
        NSLog(@"ERROR: Could not get attribute string from property %s", property_getName(property));
#endif
        return NO;
    }
#ifdef DEBUG
    NSLog(@"Property attribute string: %s", attrCString);
#endif
    NSString *attrString = [NSString stringWithUTF8String:attrCString];
    
    return [attrString containsString:@",R,"];
}

+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block
{
    Class cls = self;
    BOOL stop = NO;
    
    while (!stop && ![cls isEqual:IRObject.class]) {
        unsigned count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        
        cls = cls.superclass;
        if (properties == NULL) continue;
        
        for (unsigned i = 0; i < count; i++) {
            block(properties[i], &stop);
            if (stop) break;
        }
        
        free(properties);
    }
}

@end
